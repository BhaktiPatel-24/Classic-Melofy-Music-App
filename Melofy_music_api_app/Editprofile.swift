//
//  Editprofile.swift
//  Melofy_music_api_app
//
//  Created by Apple on 17/05/25.
//

import UIKit

class Editprofile: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var nickname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            username.text = savedUsername
        }
        if let savedNickname = UserDefaults.standard.string(forKey: "nickname") {
            nickname.text = savedNickname
        }
    }

    @IBAction func submit(_ sender: Any) {
        guard let user = username.text, !user.isEmpty,
              let nick = nickname.text, !nick.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        
        UserDefaults.standard.set(user, forKey: "username")
        UserDefaults.standard.set(nick, forKey: "nickname")
        
        
        showAlert(title: "Success", message: "Profile updated successfully.")
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}
