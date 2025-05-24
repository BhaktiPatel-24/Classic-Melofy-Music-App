//
//  LoginVC.swift
//  Melofy_music_api_app
//
//  Created by Apple on 15/05/25.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func signup(_ sender: Any) {
        if let signupVC = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as? SignupVC {
            signupVC.modalPresentationStyle = .fullScreen
            present(signupVC, animated: true, completion: nil)
        }
    }

    @IBAction func forgot(_ sender: Any) {
        if let forgotVC = storyboard?.instantiateViewController(withIdentifier: "ForgotVC") as? ForgotVC {
            forgotVC.modalPresentationStyle = .fullScreen
            present(forgotVC, animated: true, completion: nil)
        }
    }

    
    @IBAction func Login(_ sender: Any) {
        guard let enteredEmail = emailtxt.text, !enteredEmail.isEmpty,
              let enteredPassword = passwordtxt.text, !enteredPassword.isEmpty else {
            showAlert(title: "Missing Info", message: "Please enter both email and password.")
            return
        }

        let savedEmail = UserDefaults.standard.string(forKey: "email")
        let savedPassword = UserDefaults.standard.string(forKey: "password")

        if enteredEmail == savedEmail && enteredPassword == savedPassword {
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")

            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
                sceneDelegate.window?.rootViewController = tabBarVC
                sceneDelegate.window?.makeKeyAndVisible()
            }

        } else {
            
            showAlert(title: "Error", message: "Invalid email or password.")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
