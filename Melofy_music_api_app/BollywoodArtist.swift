//
//  BollywoodArtist.swift
//  Melofy_music_api_app
//
//  Created by Apple on 12/05/25.
//

import UIKit


struct Singer {
    let name: String
    let imageName: String
}


class BollywoodArtist: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let bollywoodSingers: [Singer] = [
        Singer(name: "Arijit Singh", imageName: "Arijit Singh"),
        Singer(name: "Armaan Malik", imageName: "Armaan Malik"),
        Singer(name: "Asees Kaur", imageName: "Asees Kaur"),
        Singer(name: "Asha Bhosale", imageName: "Asha Bhosale"),
        Singer(name: "Atif Aslam", imageName: "Atif Aslam"),
        Singer(name: "B Praak", imageName: "B Praak"),
        Singer(name: "Darshan Raval", imageName: "Darshan Raval"),
        Singer(name: "Dhvani Bhanushali", imageName: "Dhvani Bhanushali"),
        Singer(name: "Hemant Kumar", imageName: "Hemant Kumar"),
        Singer(name: "Jonita Gandhi", imageName: "Jonita Gandhi"),
        Singer(name: "Jubin Nautiyal", imageName: "Jubin Nautiyal"),
        Singer(name: "KK", imageName: "KK"),
        Singer(name: "Kanika Kapoor", imageName: "Kanika Kapoor"),
        Singer(name: "Kishore Kumar", imageName: "Kishore Kumar"),
        Singer(name: "Lata Mangeshkar", imageName: "Lata Mangeshkar"),
        Singer(name: "Manna Dey", imageName: "Manna Dey"),
        Singer(name: "Mohit Chauhan", imageName: "Mohit Chauhan"),
        Singer(name: "Mohammed Rafi", imageName: "Mohammed Rafi"),
        Singer(name: "Mukesh", imageName: "Mukesh"),
        Singer(name: "Neha Kakkar", imageName: "Neha Kakkar"),
        Singer(name: "Palak Muchhal", imageName: "Palak Muchhal"),
        Singer(name: "Rahat Fateh Ali Khan", imageName: "Rahat Fateh Ali Khan"),
        Singer(name: "Sachet Tandon", imageName: "Sachet Tandon"),
        Singer(name: "Shankar Mahadevan", imageName: "Shankar Mahadevan"),
        Singer(name: "Shreya Ghoshal", imageName: "Shreya Ghoshal"),
        Singer(name: "Sonu Nigam", imageName: "Sonu Nigam"),
        Singer(name: "Sunidhi Chauhan", imageName: "Sunidhi Chauhan"),
        Singer(name: "Tulsi Kumar", imageName: "Tulsi Kumar"),
        Singer(name: "Vishal Dadlani", imageName: "Vishal Dadlani")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bollywood Singers"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 250
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bollywoodSingers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singer = bollywoodSingers[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor(hex: "#D1D1D6")
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let imageSize: CGFloat = 150
        let imageView = UIImageView()
        imageView.image = UIImage(named: singer.imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageSize / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        stackView.addArrangedSubview(imageView)
        
        let nameLabel = UILabel()
        nameLabel.text = singer.name
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
        let selectedSinger = bollywoodSingers[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let songVC = storyboard.instantiateViewController(withIdentifier: "SongVC") as? SongVC {
            self.navigationItem.backButtonTitle = "Back"
            songVC.singerName = selectedSinger.name
            navigationController?.pushViewController(songVC, animated: true)
        }
    }

}

