//
//  K_popArtist.swift
//  Melofy_music_api_app
//
//  Created by Apple on 13/05/25.
//

import UIKit


struct KpopSinger {
    let name: String
    let imageName: String
}


class K_popArtist: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let koreanSingers: [KpopSinger] = [
        KpopSinger(name: "AKMU", imageName: "AKMU"),
        KpopSinger(name: "BIBI", imageName: "BIBI"),
        KpopSinger(name: "Baekhyun", imageName: "Baekhyun"),
        KpopSinger(name: "BoA", imageName: "BoA"),
        KpopSinger(name: "Cho Yong-pil", imageName: "Cho Yong-pil"),
        KpopSinger(name: "Chung Ha", imageName: "Chung Ha"),
        KpopSinger(name: "Crush", imageName: "Crush"),
        KpopSinger(name: "Dean", imageName: "Dean"),
        KpopSinger(name: "G-Dragon", imageName: "G-Dragon"),
        KpopSinger(name: "Heize", imageName: "Heize"),
        KpopSinger(name: "Hwasa", imageName: "Hwasa"),
        KpopSinger(name: "HyunA", imageName: "HyunA"),
        KpopSinger(name: "IU", imageName: "IU"),
        KpopSinger(name: "J-Hope", imageName: "J-Hope"),
        KpopSinger(name: "Jay Park", imageName: "Jay Park"),
        KpopSinger(name: "Jennie", imageName: "Jennie"),
        KpopSinger(name: "Jessi", imageName: "Jessi"),
        KpopSinger(name: "Jimin", imageName: "Jimin"),
        KpopSinger(name: "Jin", imageName: "Jin"),
        KpopSinger(name: "Jisoo", imageName: "Jisoo"),
        KpopSinger(name: "Jungkook", imageName: "Jungkook"),
        KpopSinger(name: "Kim Gun-mo", imageName: "Kim Gun-mo"),
        KpopSinger(name: "Lee Hi", imageName: "Lee Hi"),
        KpopSinger(name: "Lee Moon-sae", imageName: "Lee Moon-sae"),
        KpopSinger(name: "Lisa", imageName: "Lisa"),
        KpopSinger(name: "RM", imageName: "RM"),
        KpopSinger(name: "Rain", imageName: "Rain"),
        KpopSinger(name: "Rosé", imageName: "Rosé"),
        KpopSinger(name: "Seo Taiji", imageName: "Seo Taiji"),
        KpopSinger(name: "Seulgi", imageName: "Seulgi"),
        KpopSinger(name: "Shin Seung-hun", imageName: "Shin Seung-hun"),
        KpopSinger(name: "Suga", imageName: "Suga"),
        KpopSinger(name: "Sunmi", imageName: "Sunmi"),
        KpopSinger(name: "Taemin", imageName: "Taemin"),
        KpopSinger(name: "Taeyeon", imageName: "Taeyeon"),
        KpopSinger(name: "V", imageName: "V"),
        KpopSinger(name: "Wendy", imageName: "Wendy"),
        KpopSinger(name: "Zico", imageName: "Zico")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "K-Pop Singers"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return koreanSingers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = koreanSingers[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor(hex: "#D1D1D6")
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageSize: CGFloat = 150
        let imageView = UIImageView()
        imageView.image = UIImage(named: artist.imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageSize / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(imageView)
        
        let nameLabel = UILabel()
        nameLabel.text = artist.name
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textAlignment = .center
        stackView.addArrangedSubview(nameLabel)
        
        cell.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize)
        ])
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArtist = koreanSingers[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let songVC = storyboard.instantiateViewController(withIdentifier: "SongVC") as? SongVC {
            self.navigationItem.backButtonTitle = "Back"
            songVC.singerName = selectedArtist.name
            navigationController?.pushViewController(songVC, animated: true)
        }
    }
}
