//
//  AuthenticationHelper.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 24/03/24.
//

import Foundation
class AuthenticationHelper {
    
    func checkIfAlreadyLoggedIn()-> Bool {
        let keychainHelper = KeychainHelper.standard
        let accessTokenExists = keychainHelper.hasToken(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
        let refreshTokenExists = keychainHelper.hasToken(service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
        
        if accessTokenExists && refreshTokenExists {
            return true
        }
        else {
            return false
        }

    }
}
