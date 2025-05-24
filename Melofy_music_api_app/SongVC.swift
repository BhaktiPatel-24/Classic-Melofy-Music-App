import UIKit
import AVFoundation
import Alamofire


struct Ssong {
    let trackName: String
    let artistName: String
    let artworkUrl: String
    let previewUrl: String
}

class SongVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var singerName: String = ""
    var songs: [Ssong] = []
    
    
    var audioPlayer: AVPlayer?
    var currentSongIndex: Int = -1
    var isPlaying: Bool = false
    var countdown: Int = 30
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = singerName
        setupTableView()
        fetchSongsWithAlamofire()
        
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

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    

    func fetchSongsWithAlamofire() {
        let query = singerName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "https://itunes.apple.com/search?term=\(query)&media=music&entity=song"
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let results = json["results"] as? [[String: Any]] {
                    var temp: [Ssong] = []
                    for item in results {
                        if let name = item["trackName"] as? String,
                           let artist = item["artistName"] as? String,
                           let artwork = item["artworkUrl100"] as? String,
                           let preview = item["previewUrl"] as? String {
                            temp.append(Ssong(trackName: name, artistName: artist, artworkUrl: artwork, previewUrl: preview))
                        }
                    }
                    self.songs = temp
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("AF Error: \(error)")
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
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
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        if let url = URL(string: song.artworkUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = img
                    }
                }
            }
        }

        let titleLabel = UILabel()
        titleLabel.text = song.trackName
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 16)

        let artistLabel = UILabel()
        artistLabel.text = song.artistName
        artistLabel.textAlignment = .center
        artistLabel.font = .systemFont(ofSize: 14)

        let playPauseButton = UIButton(type: .system)
        let isSongPlaying = indexPath.row == currentSongIndex && isPlaying
        playPauseButton.setImage(UIImage(systemName: isSongPlaying ? "pause.fill" : "play.fill"), for: .normal)
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
        durationLabel.tag = 500 + indexPath.row
        durationLabel.text = indexPath.row == currentSongIndex ? "\(countdown)" : "0:30"
        durationLabel.font = .systemFont(ofSize: 12)

        let buttonStack = UIStackView(arrangedSubviews: [playPauseButton, likeButton, shareButton, saveButton, durationLabel])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 15
        buttonStack.alignment = .center

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(artistLabel)
        stackView.addArrangedSubview(buttonStack)

        cell.contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
        ])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSongIndex = indexPath.row
        playSong(at: indexPath)
    }

    
    
    @objc func togglePlayPause(_ sender: UIButton) {
        let index = sender.tag
        if currentSongIndex == index {
            isPlaying.toggle()
            isPlaying ? audioPlayer?.play() : audioPlayer?.pause()
            isPlaying ? startTimer() : timer?.invalidate()
        } else {
            currentSongIndex = index
            playSong(at: IndexPath(row: index, section: 0))
        }
        tableView.reloadData()
    }

    func playSong(at indexPath: IndexPath) {
        let song = songs[indexPath.row]
        guard let url = URL(string: song.previewUrl) else { return }

        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
        isPlaying = true
        countdown = 30
        startTimer()

        NotificationCenter.default.addObserver(self, selector: #selector(songDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem)

        tableView.reloadData()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    @objc func songDidFinishPlaying(_ notification: Notification) {
        if currentSongIndex < songs.count - 1 {
            currentSongIndex += 1
        } else {
            currentSongIndex = 0
        }
        playSong(at: IndexPath(row: currentSongIndex, section: 0))
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

    
    
    @objc func didTapLike(_ sender: UIButton) {
        let isLiked = sender.currentImage == UIImage(systemName: "heart.fill")
        let newImage = isLiked ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        sender.setImage(newImage, for: .normal)
        sender.tintColor = isLiked ? .gray : .black
    }

    @objc func didTapShare(_ sender: UIButton) {
        let song = songs[sender.tag]
        let text = "Check out this song: \(song.trackName) by \(song.artistName)"
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }

    @objc func saveOffline(_ sender: UIButton) {
        let song = songs[sender.tag]
        guard let url = URL(string: song.previewUrl) else { return }

        let fileName = "\(song.trackName).mp3"
        let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

        URLSession.shared.downloadTask(with: url) { tempURL, _, error in
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
}
