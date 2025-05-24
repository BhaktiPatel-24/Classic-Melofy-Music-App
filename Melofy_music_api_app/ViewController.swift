//
//  ViewController.swift
//  Melofy_music_api_app
//
//  Created by Apple on 11/05/25.
//

import UIKit
import Alamofire
import AVFoundation


struct Song: Codable {
    let trackName: String?
    let artistName: String?
    let artworkUrl100: String?
    let previewUrl: String?
}

struct iTunesResponse: Codable {
    let results: [Song]
}


extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") { hexSanitized.remove(at: hexSanitized.startIndex) }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var songs: [Song] = []
    var audioPlayer: AVPlayer?
    var currentSongIndex: Int = -1
    var isPlaying: Bool = false
    var timer: Timer?
    var countdown: Int = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchSongs(search: "arijit")
        navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.isTranslucent = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.pause()
        timer?.invalidate()
        isPlaying = false
        countdown = 30
        currentSongIndex = -1
        tableView.reloadData()
    }

    
    
    

    
     func fetchSongs(search: String) {
        let url = "https://itunes.apple.com/search?term=\(search)&media=music"
        AF.request(url).responseDecodable(of: iTunesResponse.self) { response in
            switch response.result {
            case .success(let data):
                self.songs = data.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let song = songs[indexPath.row]
        cell.backgroundColor = indexPath.row == currentSongIndex ? UIColor(hex: "#A9CCE3") : UIColor(hex: "#D1D1D6")

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        if let urlString = song.artworkUrl100, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
        }

        let titleLabel = UILabel()
        titleLabel.text = song.trackName
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)

        let artistLabel = UILabel()
        artistLabel.text = song.artistName
        artistLabel.textAlignment = .center
        artistLabel.font = UIFont.systemFont(ofSize: 14)

        let playPauseButton = UIButton(type: .system)
        let isSongPlaying = indexPath.row == currentSongIndex && isPlaying
        let icon = isSongPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: icon), for: .normal)
        playPauseButton.tintColor = .black
        playPauseButton.tag = indexPath.row
        playPauseButton.addTarget(self, action: #selector(togglePlayPause(_:)), for: .touchUpInside)

        let likeButton = UIButton(type: .system)
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .gray
        likeButton.tag = indexPath.row
        likeButton.addTarget(self, action: #selector(didTapLike(_:)), for: .touchUpInside)

        let shareButton = UIButton(type: .system)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .black
        shareButton.tag = indexPath.row
        shareButton.addTarget(self, action: #selector(didTapShare(_:)), for: .touchUpInside)

        let saveButton = UIButton(type: .system)
        saveButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        saveButton.tintColor = .black
        saveButton.tag = indexPath.row
        saveButton.addTarget(self, action: #selector(saveOffline(_:)), for: .touchUpInside)

        let durationLabel = UILabel()
        durationLabel.tag = 500 + indexPath.row // Unique tag for timer label
        durationLabel.text = indexPath.row == currentSongIndex ? "\(countdown)" : "0:30"
        durationLabel.font = UIFont.systemFont(ofSize: 12)

        let buttonStack = UIStackView(arrangedSubviews: [playPauseButton, likeButton, shareButton, saveButton, durationLabel])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 15
        buttonStack.alignment = .center
        buttonStack.distribution = .equalSpacing

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(artistLabel)
        stackView.addArrangedSubview(buttonStack)

        cell.contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150)
        ])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }

    
    @objc func togglePlayPause(_ sender: UIButton) {
        let index = sender.tag

        if currentSongIndex == index {
            isPlaying.toggle()
            if isPlaying {
                audioPlayer?.play()
                startTimer()
            } else {
                audioPlayer?.pause()
                timer?.invalidate()
            }
        } else {
            currentSongIndex = index
            playSong(at: IndexPath(row: index, section: 0))
        }

        tableView.reloadData()
    }

    func playSong(at indexPath: IndexPath) {
        let song = songs[indexPath.row]
        guard let previewUrl = song.previewUrl, let url = URL(string: previewUrl) else { return }

        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
        isPlaying = true
        countdown = 30
        startTimer()

        NotificationCenter.default.addObserver(self, selector: #selector(songDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem)

        tableView.reloadData()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.countdown > 0 {
                self.countdown -= 1
                if let label = self.tableView.cellForRow(at: IndexPath(row: self.currentSongIndex, section: 0))?.contentView.viewWithTag(500 + self.currentSongIndex) as? UILabel {
                    label.text = "\(self.countdown)"
                }
            } else {
                self.timer?.invalidate()
            }
        }
    }

    @objc func songDidFinishPlaying(_ notification: Notification) {
        if currentSongIndex < songs.count - 1 {
            currentSongIndex += 1
        } else {
            currentSongIndex = 0
        }
        playSong(at: IndexPath(row: currentSongIndex, section: 0))
    }

    @objc func didTapLike(_ sender: UIButton) {
        let isLiked = sender.currentImage == UIImage(systemName: "heart.fill")
        let newImage = isLiked ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        sender.setImage(newImage, for: .normal)
        sender.tintColor = isLiked ? .gray : .black
    }

    @objc func didTapShare(_ sender: UIButton) {
        let song = songs[sender.tag]
        let text = "Check out this song: \(song.trackName ?? "Unknown") by \(song.artistName ?? "")"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }

    @objc func saveOffline(_ sender: UIButton) {
        let song = songs[sender.tag]
        guard let previewUrl = song.previewUrl, let url = URL(string: previewUrl) else { return }

        let fileName = "\(song.trackName ?? "audio").mp3"
        let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

        URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL = tempURL, error == nil else { return }
            do {
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                UserDefaults.standard.set(destinationURL.path, forKey: fileName)
                print("Saved to: \(destinationURL)")
            } catch {
                print("Save failed: \(error)")
            }
        }.resume()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSongIndex = indexPath.row
        playSong(at: indexPath)
    }
    
}
