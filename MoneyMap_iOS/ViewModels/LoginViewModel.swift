//
//  LoginViewModel.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 26/02/24.
//

import Foundation

final class LoginViewModel{
    
    let title = "Login"
    
    var userMessage: Observable<String?> = Observable(nil)
    
    var isAuthenticated: Observable<Bool?> = Observable(false)
    
    var updateLoadingStatus: ((Bool) -> Void)?
    
    private let keychainHelper = KeychainHelper.standard
    
    
    func loginUser(email: String, password: String){
        
        //start progress indicator
        updateLoadingStatus?(true)
        
        DispatchQueue.global().async {
            
            AuthWebService().authenticateUser(email: email, password: password){[weak self] result in
                
                DispatchQueue.main.async {
                    self?.updateLoadingStatus?(false)
                    switch result {
                    case .success(let tokens):
                        // Store tokens in Keychain
                        if let accessTokenData = tokens.accessToken.data(using: .utf8),
                           let refreshTokenData = tokens.refreshToken.data(using: .utf8) {
                            self?.keychainHelper.save(accessTokenData, service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                            self?.keychainHelper.save(refreshTokenData, service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
                            
                        }
                        //self?.userMessage.value = "Login successfully"
                        self?.isAuthenticated.value = true
                    case .failure(let error):
                        self?.userMessage.value = "Error occurred: \(error.localizedDescription)"
                    }
                    
                }
                
            }
        }
        
        
    }
 
    
}

