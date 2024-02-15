//
//  ImageConverter.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 10/02/24.
//
import UIKit

final class ImageConverter {

    static func convertImageToBase64String(img: UIImage) -> String {
        let imageData = img.jpegData(compressionQuality: 0.50)! as NSData
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
}

