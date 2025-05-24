//
//  Profile.swift
//  Melofy_music_api_app
//
//  Created by Apple on 13/05/25.
//

import UIKit
import PhotosUI
import TOCropViewController

class Profile: UIViewController, PHPickerViewControllerDelegate, TOCropViewControllerDelegate {
    
    @IBOutlet weak var usename: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var image: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGesture)

        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = image.frame.size.width / 2
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.black.cgColor

        
        loadProfileInfo()

        
        NotificationCenter.default.addObserver(self, selector: #selector(loadProfileInfo), name: NSNotification.Name("ProfileUpdated"), object: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfileInfo()
    }

    @objc func loadProfileInfo() {
        if let imageData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
           let savedImage = UIImage(data: imageData) {
            image.image = savedImage
            updateTabBarIcon(with: savedImage)
        } else {
            let defaultImage = UIImage(systemName: "person.fill.viewfinder")!
            image.image = defaultImage
            image.tintColor = .black 
            updateTabBarIcon(with: defaultImage)
        }

        usename.text = UserDefaults.standard.string(forKey: "username") ?? "Username"
        nickname.text = UserDefaults.standard.string(forKey: "nickname") ?? "Nickname"
    }

    
    @objc func selectPhoto() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }

        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                guard let self = self, let selectedImage = image as? UIImage else { return }

                let cropVC = TOCropViewController(croppingStyle: .default, image: selectedImage)
                cropVC.delegate = self
                self.present(cropVC, animated: true)
            }
        }
    }

    func cropViewController(_ cropViewController: TOCropViewController, didCropTo croppedImage: UIImage, with cropRect: CGRect, angle: Int) {
        self.image.image = croppedImage

        if let imageData = croppedImage.pngData() {
            UserDefaults.standard.set(imageData, forKey: "userProfilePhoto")
        }

        updateTabBarIcon(with: croppedImage)
        cropViewController.dismiss(animated: true)
    }

    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }

    
    func updateTabBarIcon(with image: UIImage) {
        guard let tabBarItems = self.tabBarController?.tabBar.items else { return }

        let iconSize = CGSize(width: 22, height: 22)
        let circularImage = makeCircularImage(from: image, size: iconSize)
        let finalImage = circularImage.withRenderingMode(.alwaysOriginal)

        if tabBarItems.indices.contains(4) {
            tabBarItems[4].image = finalImage
            tabBarItems[4].selectedImage = finalImage
        }
    }

    func makeCircularImage(from image: UIImage, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        UIBezierPath(ovalIn: rect).addClip()
        image.draw(in: rect)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let borderWidth: CGFloat = 2
        let totalSize = CGSize(width: size.width + borderWidth * 2, height: size.height + borderWidth * 2)
        UIGraphicsBeginImageContextWithOptions(totalSize, false, 0.0)

        let borderRect = CGRect(origin: .zero, size: totalSize)
        let borderPath = UIBezierPath(ovalIn: borderRect)
        UIColor.black.setFill()
        borderPath.fill()

        croppedImage?.draw(in: CGRect(x: borderWidth, y: borderWidth, width: size.width, height: size.height))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finalImage ?? image
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
