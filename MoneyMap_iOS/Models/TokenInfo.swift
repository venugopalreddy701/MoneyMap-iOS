//
//  TokenInfo.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 24/03/24.
//

import Foundation

struct TokenInfo : Decodable {
    
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let id: Int
    let email: String?
    let profile: String
    
}
