//
//  SignupVC.swift
//  Melofy_music_api_app
//
//  Created by Apple on 15/05/25.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var usertxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    @IBOutlet weak var mobiletxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signup(_ sender: UIButton) {
        view.endEditing(true)

        guard let username = usertxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
            showAlert(message: "Username is required.")
            return
        }

        guard let password = passwordtxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            showAlert(message: "Password is required.")
            return
        }

        guard let mobile = mobiletxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !mobile.isEmpty else {
            showAlert(message: "Mobile number is required.")
            return
        }

        guard let email = emailtxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            showAlert(message: "Email is required.")
            return
        }
        
        UserDefaults.standard.set(username, forKey: "username")
        NotificationCenter.default.post(name: NSNotification.Name("ProfileUpdated"), object: nil)

        
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !passwordPredicate.evaluate(with: password) {
            showAlert(message: "Password must be at least 6 characters, include 1 uppercase letter and 1 special character.")
            return
        }

        
        let otp = String(format: "%04d", Int.random(in: 1000...9999))

       
        saveUserDataToUserDefaults(username: username, password: password, mobile: mobile, email: email, otp: otp)

        
        goToOTPVC()
    }

    func saveUserDataToUserDefaults(username: String, password: String, mobile: String, email: String, otp: String) {
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "username")
        defaults.set(password, forKey: "password")
        defaults.set(mobile, forKey: "mobile")
        defaults.set(email, forKey: "email")
        defaults.set(otp, forKey: "otp")

        print("User data saved to UserDefaults.")
    }

    func goToOTPVC() {
        if let otpVC = storyboard?.instantiateViewController(withIdentifier: "OTPVC") {
//            otpVC.modalPresentationStyle = .fullScreen
            present(otpVC, animated: true) {
                print(" OTPVC presented")
            }
        } else {
            print(" OTPVC not found in storyboard!")
        }
    }

    func showAlert(message: String, title: String = "Alert") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
