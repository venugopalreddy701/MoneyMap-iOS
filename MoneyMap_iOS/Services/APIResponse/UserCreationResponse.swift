//
//  UserCreationResponse.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 26/08/24.
//

import Foundation

struct UserCreationResponse: Decodable {
    
    let id: Int
    let email: String
    let profile: String
    
}

