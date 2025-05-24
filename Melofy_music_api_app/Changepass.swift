//
//  Changepass.swift
//  Melofy_music_api_app
//
//  Created by Apple on 17/05/25.
//

import UIKit

class Changepass: UIViewController {
    
    @IBOutlet weak var oldpass: UITextField!
    @IBOutlet weak var newpass: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func submit(_ sender: Any) {
        guard let oldPassword = oldpass.text, !oldPassword.isEmpty,
              let newPassword = newpass.text, !newPassword.isEmpty else {
            showAlert(title: "Error", message: "Please fill in both fields.")
            return
        }

        let savedPassword = UserDefaults.standard.string(forKey: "password")

        if oldPassword == savedPassword {
            
            UserDefaults.standard.set(newPassword, forKey: "password")
            showAlert(title: "Success", message: """
                Your password has been saved successfully.
                For better security, use a strong password (letters, numbers & symbols).
                """)
            oldpass.text = ""
            newpass.text = ""
        } else {
            showAlert(title: "Error", message: "Old password is incorrect.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}
