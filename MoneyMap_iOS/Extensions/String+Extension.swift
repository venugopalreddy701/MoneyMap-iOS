//
//  String+Extension.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 24/08/24.
//

import Foundation
import UIKit

extension String{
    
    static func fromBase64String(_ base64String: String) -> UIImage? {
           guard let imageData = Data(base64Encoded: base64String) else { return nil }
           return UIImage(data: imageData)
       }
    
    
}
