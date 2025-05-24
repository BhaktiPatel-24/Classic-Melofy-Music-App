//
//  HollywoodArtist.swift
//  Melofy_music_api_app
//
//  Created by Apple on 13/05/25.
//

import UIKit


struct Artist {
    let name: String
    let imageName: String
}

class HollywoodArtist: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
   
    let hollywoodArtists: [Artist] = [
        Artist(name: "Frank Sinatra", imageName: "Frank Sinatra"),
        Artist(name: "Elvis Presley", imageName: "Elvis Presley"),
        Artist(name: "Billie Holiday", imageName: "Billie Holiday"),
        Artist(name: "Nat King Cole", imageName: "Nat King Cole"),
        Artist(name: "Dean Martin", imageName: "Dean Martin"),
        Artist(name: "Ella Fitzgerald", imageName: "Ella Fitzgerald"),
        Artist(name: "Bing Crosby", imageName: "Bing Crosby"),
        Artist(name: "Ray Charles", imageName: "Ray Charles"),
        Artist(name: "Louis Armstrong", imageName: "Louis Armstrong"),
        Artist(name: "Aretha Franklin", imageName: "Aretha Franklin"),
        Artist(name: "Justin Bieber", imageName: "Justin Bieber"),
        Artist(name: "Taylor Swift", imageName: "Taylor Swift"),
        Artist(name: "Ariana Grande", imageName: "Ariana Grande"),
        Artist(name: "Ed Sheeran", imageName: "Ed Sheeran"),
        Artist(name: "Billie Eilish", imageName: "Billie Eilish"),
        Artist(name: "Bruno Mars", imageName: "Bruno Mars"),
        Artist(name: "Beyoncé", imageName: "Beyoncé"),
        Artist(name: "The Weeknd", imageName: "The Weeknd"),
        Artist(name: "Lady Gaga", imageName: "Lady Gaga"),
        Artist(name: "Harry Styles", imageName: "Harry Styles"),
        Artist(name: "Olivia Rodrigo", imageName: "Olivia Rodrigo"),
        Artist(name: "Selena Gomez", imageName: "Selena Gomez"),
        Artist(name: "Shawn Mendes", imageName: "Shawn Mendes"),
        Artist(name: "Sam Smith", imageName: "Sam Smith"),
        Artist(name: "Dua Lipa", imageName: "Dua Lipa")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hollywood Singers"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hollywoodArtists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = hollywoodArtists[indexPath.row]
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
        let selectedArtist = hollywoodArtists[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let songVC = storyboard.instantiateViewController(withIdentifier: "SongVC") as? SongVC {
            self.navigationItem.backButtonTitle = "Back"
            songVC.singerName = selectedArtist.name
            navigationController?.pushViewController(songVC, animated: true)
        }
    }
}
