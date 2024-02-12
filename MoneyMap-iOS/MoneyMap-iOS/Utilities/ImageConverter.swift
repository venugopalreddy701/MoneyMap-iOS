//
//  ImageConverter.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 10/02/24.
//

import Foundation
import UIKit
class ImageConverter{
    
    static func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
}
