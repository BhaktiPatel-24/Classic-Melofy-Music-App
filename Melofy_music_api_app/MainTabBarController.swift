//
//  MainTabBarController.swift
//  Melofy_music_api_app
//
//  Created by Apple on 14/05/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let imageData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
           let savedImage = UIImage(data: imageData) {
            
            let circularImage = makeCircularImage(from: savedImage, size: CGSize(width: 22, height: 22))
            let finalImage = circularImage.withRenderingMode(.alwaysOriginal)

           
            if self.tabBar.items?.count ?? 0 > 4 {
                self.tabBar.items?[4].image = finalImage
                self.tabBar.items?[4].selectedImage = finalImage
            }
        }
    }

    
    func makeCircularImage(from image: UIImage, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()

        
        image.draw(in: rect)

        
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        
        let finalImage = circularImage?.withBorder(width: 2, color: .black) ?? image
        return finalImage
    }
}

extension UIImage {
    func withBorder(width: CGFloat, color: UIColor) -> UIImage {
        let size = CGSize(width: self.size.width + width * 2, height: self.size.height + width * 2)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()

        
        context?.setFillColor(color.cgColor)
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))

        
        self.draw(in: CGRect(x: width, y: width, width: self.size.width, height: self.size.height))

        let imageWithBorder = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithBorder ?? self
    }
}
