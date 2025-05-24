//
//  Personlditails.swift
//  Melofy_music_api_app
//
//  Created by Apple on 17/05/25.
//

import UIKit

class Personlditails: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var mobilenumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        username.text = UserDefaults.standard.string(forKey: "username") ?? "No Name"
        email.text = UserDefaults.standard.string(forKey: "email") ?? "No Email"
        mobilenumber.text = UserDefaults.standard.string(forKey: "mobile") ?? "No Number"
        
        
        if let imageData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
           let profileImage = UIImage(data: imageData) {
            image.tintColor = .black 
            image.image = profileImage
        } else {
            image.image = UIImage(systemName: "person.fill.viewfinder")
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.black.cgColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
    }
}
