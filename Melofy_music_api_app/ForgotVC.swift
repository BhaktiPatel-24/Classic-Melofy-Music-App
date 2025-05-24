//
//  ForgotVC.swift
//  Melofy_music_api_app
//
//  Created by Apple on 15/05/25.
//

import UIKit

class ForgotVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func submit(_ sender: UIButton) {
        view.endEditing(true)

        
        guard let enteredEmail = email.text?.trimmingCharacters(in: .whitespacesAndNewlines), !enteredEmail.isEmpty else {
            showAlert(message: "Email is required.")
            return
        }

        
        guard let newPassword = passwordtxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !newPassword.isEmpty else {
            showAlert(message: "New password is required.")
            return
        }

        
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !passwordPredicate.evaluate(with: newPassword) {
            showAlert(message: "Password must be at least 6 characters, include 1 uppercase letter and 1 special character.")
            return
        }

        
        var userData = readUserData() ?? [:]

        
        guard let savedEmail = userData["email"], savedEmail == enteredEmail else {
            showAlert(message: "Email not registered.")
            return
        }

        
        let otp = String(format: "%04d", Int.random(in: 1000...9999))
        userData["password"] = newPassword
        userData["otp"] = otp
        saveUserData(data: userData)

        print("OTP for verification: \(otp)")

        
        goToOTPVC(with: otp)
    }

    func readUserData() -> [String: String]? {
        let fileManager = FileManager.default
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let fileURL = directory.appendingPathComponent("userdata.plist")

        if !fileManager.fileExists(atPath: fileURL.path) {
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            if let dict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String] {
                return dict
            }
        } catch {
            print("Error reading file: \(error)")
        }

        return nil
    }

    func saveUserData(data: [String: String]) {
        let fileManager = FileManager.default
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let fileURL = directory.appendingPathComponent("userdata.plist")

        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: data, format: .xml, options: 0)
            try plistData.write(to: fileURL)
            print("User data updated and saved.")
        } catch {
            print("Error saving user data: \(error)")
        }
    }

    func goToOTPVC(with otp: String) {
        if let otpVC = storyboard?.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC {
            otpVC.receivedOTP = otp
            present(otpVC, animated: true) {
                print("OTPVC presented.")
            }
        } else {
            print("OTPVC not found in storyboard!")
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
