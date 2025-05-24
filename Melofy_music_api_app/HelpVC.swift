//
//  HelpVC.swift
//  Melofy_music_api_app
//
//  Created by Apple on 17/05/25.
//

import UIKit
import MessageUI

class HelpVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBAction func submit(_ sender: UIButton) {
        guard let message = messageTextView.text, !message.isEmpty else {
            showAlert(title: "Error", message: "Please write your message first.")
            return
        }
        
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["support@melofy.com"])
            mailVC.setSubject("Help Request from Melofy User")
            mailVC.setMessageBody(message, isHTML: false)
            present(mailVC, animated: true)
        } else {
            showAlert(title: "Mail Not Configured", message: "Please setup mail on your device.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
        
        if result == .sent {
            showAlert(title: "Thank You", message: "Your message has been sent successfully.")
            messageTextView.text = ""
        }
    }
}
