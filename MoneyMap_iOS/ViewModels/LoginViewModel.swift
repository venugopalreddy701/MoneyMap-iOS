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
    
    var isAuthenticated: Observable<Bool> = Observable(false)
    
    var updateLoadingStatus: ((Bool) -> Void)?
    
    private let keychainHelper = KeychainHelper.standard
    
    
    func loginUser(email: String?, password: String?){
        
        guard let email=email else {
            self.userMessage.value = "Please enter your email."
            return
          }
        guard let password=password else {
            self.userMessage.value = "Please enter your password."
            return
          }
        
        //start progress indicator
        updateLoadingStatus?(true)
        
            let userInfo = UserInfo(email: email, password: password)
        
//            AuthWebService().authenticateUser(userInfo: userInfo){[weak self] result in
//                
//                DispatchQueue.main.async {
//                    self?.updateLoadingStatus?(false)
//                    switch result {
//                    case .success(let tokenInfo):
//                        // add loggers in future for tokens
//                        if let accessTokenData = tokenInfo.accessToken.data(using: .utf8),
//                           let refreshTokenData = tokenInfo.refreshToken.data(using: .utf8) {
//                            self?.keychainHelper.save(accessTokenData, service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
//                            self?.keychainHelper.save(refreshTokenData, service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
//                            
//                        }
//                        //self?.userMessage.value = "Login successfully"
//                        self?.isAuthenticated.value = true
//                    case .failure(let error):
//                        self?.userMessage.value = "Error occurred: \(error.localizedDescription)"
//                    }
//                    
//                }
//        }
        
        NetworkService.shared.authenticateUser(userInfo: userInfo){[weak self] result in
            
            DispatchQueue.main.async {
                self?.updateLoadingStatus?(false)
                switch result {
                case .success(let tokenInfo):
                    // add loggers in future for tokens
                    if let accessTokenData = tokenInfo.accessToken.data(using: .utf8),
                       let refreshTokenData = tokenInfo.refreshToken.data(using: .utf8) {
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

