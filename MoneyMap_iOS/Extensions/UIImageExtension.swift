//
//  UIImageExtension.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 10/02/24.
//

import UIKit

extension UIImage {
    
    func toBase64String(compressionQuality: CGFloat = 0.5) -> String? {
        guard let imageData = self.jpegData(compressionQuality: compressionQuality) else { return nil }
        return imageData.base64EncodedString(options: [])
    }
    
    static func fromBase64String(_ base64String: String) -> UIImage? {
           guard let imageData = Data(base64Encoded: base64String) else { return nil }
           return UIImage(data: imageData)
       }
    
    
}

