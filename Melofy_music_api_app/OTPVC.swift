//
//  OTPVC.swift
//  Melofy_music_api_app
//
//  Created by Apple on 15/05/25.
//

import UIKit

class OTPVC: UIViewController {

    
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var resend: UILabel!

    
    var savedOTP: String?
    var timer: Timer?
    var receivedOTP: String?
    var secondsRemaining = 60

   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupResendTap()
        loadSavedOTP()
        startOTPTimer()
        showOTPBanner()
    }

    
    private func setupResendTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resendTapped(_:)))
        resend.isUserInteractionEnabled = true
        resend.addGestureRecognizer(tapGesture)
    }

    private func loadSavedOTP() {
        if let data = readUserData() {
            savedOTP = data["otp"]
        }
    }

    
    func startOTPTimer() {
        secondsRemaining = 60
        time.text = "Time left: \(secondsRemaining)s"
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.secondsRemaining -= 1
            self.time.text = "Time left: \(self.secondsRemaining)s"

            if self.secondsRemaining <= 0 {
                timer.invalidate()
                self.savedOTP = nil
                self.showBanner(message: "OTP expired. Please resend.", backgroundColor: .systemGray)
                self.time.text = "OTP expired"
            }
        }
    }

   
    @IBAction func submit(_ sender: Any) {
        let otpEntered = [txt1.text, txt2.text, txt3.text, txt4.text].compactMap { $0 }.joined()

        if let validOTP = savedOTP, otpEntered == validOTP {
            showBanner(message: "OTP Verified Successfully!", backgroundColor: .systemGray)
            timer?.invalidate()
        }
           UserDefaults.standard.set(true, forKey: "isLoggedIn")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {

            sceneDelegate.window?.rootViewController = tabBarController
            sceneDelegate.window?.makeKeyAndVisible()
        }

        else {
            showBanner(message: "Invalid or expired OTP. Try again.", backgroundColor: .systemGray)
        }
    }

    @objc func resendTapped(_ sender: UITapGestureRecognizer) {
        let newOTP = String(format: "%04d", Int.random(in: 1000...9999))
        savedOTP = newOTP
        saveNewOTPToFile(otp: newOTP)
        startOTPTimer()
        showOTPBanner()
    }

    
    func readUserData() -> [String: String]? {
        let fileManager = FileManager.default
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = directory.appendingPathComponent("userdata.plist")

        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }

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
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = directory.appendingPathComponent("userdata.plist")

        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: data, format: .xml, options: 0)
            try plistData.write(to: fileURL)
        } catch {
            print("Error saving data: \(error)")
        }
    }

    func saveNewOTPToFile(otp: String) {
        var data = readUserData() ?? [:]
        data["otp"] = otp
        saveUserData(data: data)
    }

    
    func fillOTPFields(with otp: String) {
        guard otp.count == 4 else { return }
        let chars = Array(otp)
        txt1.text = String(chars[0])
        txt2.text = String(chars[1])
        txt3.text = String(chars[2])
        txt4.text = String(chars[3])
    }

    
    func showOTPBanner() {
        guard let otp = savedOTP else { return }

        let bannerHeight: CGFloat = 110
        let banner = UIView(frame: CGRect(x: 0, y: -bannerHeight, width: view.frame.width, height: bannerHeight))
        banner.backgroundColor = .black
        banner.tag = 999

        let appNameLabel = UILabel(frame: CGRect(x: 16, y: 8, width: banner.frame.width - 32, height: 20))
        appNameLabel.text = "Classic Melofy"
        appNameLabel.textColor = .white
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        banner.addSubview(appNameLabel)

        let companyLabel = UILabel(frame: CGRect(x: 16, y: 30, width: banner.frame.width - 32, height: 18))
        companyLabel.text = "From: +91 ***** **578"
        companyLabel.textColor = .white
        companyLabel.font = UIFont.systemFont(ofSize: 13)
        banner.addSubview(companyLabel)

        let messageLabel = UILabel(frame: CGRect(x: 16, y: 52, width: banner.frame.width - 32, height: 20))
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.text = "Your OTP has been sent. Use within 60 seconds."
        banner.addSubview(messageLabel)

        
        let copyButton = UIButton(type: .system)
        copyButton.frame = CGRect(x: banner.frame.width - 140, y: 75, width: 60, height: 30)
        copyButton.setTitle("Copy", for: .normal)
        copyButton.setTitleColor(.black, for: .normal)
        copyButton.backgroundColor = .systemGray
        copyButton.layer.cornerRadius = 6
        copyButton.addTarget(self, action: #selector(copyOTP(_:)), for: .touchUpInside)
        banner.addSubview(copyButton)

       
        let autofillButton = UIButton(type: .system)
        autofillButton.frame = CGRect(x: banner.frame.width - 70, y: 75, width: 60, height: 30)
        autofillButton.setTitle("Autofill", for: .normal)
        autofillButton.setTitleColor(.black, for: .normal)
        autofillButton.backgroundColor = .systemGray
        autofillButton.layer.cornerRadius = 6
        autofillButton.addTarget(self, action: #selector(autofillOTP(_:)), for: .touchUpInside)
        banner.addSubview(autofillButton)

       
        view.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
        view.addSubview(banner)

        UIView.animate(withDuration: 0.4) {
            banner.frame.origin.y = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            UIView.animate(withDuration: 0.4) {
                banner.frame.origin.y = -bannerHeight
            } completion: { _ in
                banner.removeFromSuperview()
            }
        }
    }

    
    @objc func copyOTP(_ sender: UIButton) {
        guard let otp = savedOTP else { return }
        UIPasteboard.general.string = otp
        showBanner(message: "OTP copied to clipboard!", backgroundColor: .systemGray)
    }

    @objc func autofillOTP(_ sender: UIButton) {
        guard let otp = savedOTP else { return }
        fillOTPFields(with: otp)
        view.endEditing(true)
        showBanner(message: "OTP autofilled!", backgroundColor: .systemGray)
    }

    
    func showBanner(message: String, backgroundColor: UIColor = .black) {
        let bannerHeight: CGFloat = 60
        let banner = UIView(frame: CGRect(x: 0, y: -bannerHeight, width: view.frame.width, height: bannerHeight))
        banner.backgroundColor = backgroundColor
        banner.tag = 998

        let label = UILabel(frame: CGRect(x: 16, y: 15, width: banner.frame.width - 32, height: 30))
        label.text = message
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        banner.addSubview(label)

        view.subviews.filter { $0.tag == 998 }.forEach { $0.removeFromSuperview() }
        view.addSubview(banner)

        UIView.animate(withDuration: 0.4) {
            banner.frame.origin.y = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.4) {
                banner.frame.origin.y = -bannerHeight
            } completion: { _ in
                banner.removeFromSuperview()
            }
        }
    }
}
