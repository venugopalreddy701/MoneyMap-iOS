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
    
}