//
//  SettingsVC.swift
//  Melofy_music_api_app
//
//  Created by Apple on 17/05/25.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func logouts(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")

            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                sceneDelegate.window?.rootViewController = loginVC
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func dedat(_ sender: Any) {
        let passwordAlert = UIAlertController(title: "Delete Account", message: "Please enter your password to confirm.", preferredStyle: .alert)
        passwordAlert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let confirmAction = UIAlertAction(title: "Next", style: .default) { _ in
            let enteredPassword = passwordAlert.textFields?.first?.text ?? ""
            
            
            
            self.showDeleteConfirmation()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        passwordAlert.addAction(confirmAction)
        passwordAlert.addAction(cancelAction)
        
        present(passwordAlert, animated: true, completion: nil)
    }
    
    private func showDeleteConfirmation() {
        let confirmAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
                UserDefaults.standard.synchronize()
            }

            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupVC")
                sceneDelegate.window?.rootViewController = signupVC
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        confirmAlert.addAction(deleteAction)
        confirmAlert.addAction(cancelAction)
        
        present(confirmAlert, animated: true, completion: nil)
    }


    private func goToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
}

