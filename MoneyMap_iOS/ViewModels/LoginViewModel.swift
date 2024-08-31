//
//  LoginViewModel.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 26/02/24.
//

import Foundation

final class LoginViewModel {
    
    let title = "Login"
    
    var userMessage: Observable<String?> = Observable(nil)
    var isAuthenticated: Observable<Bool> = Observable(false)
    var updateLoadingStatus: ((Bool) -> Void)?
    
    private let keychainHelper = KeychainHelper.standard
    
    func loginUser(email: String?, password: String?) {
        
        guard let email = email, !email.isEmpty else {
            self.userMessage.value = "Please enter your email."
            return
        }
        
        guard let password = password, !password.isEmpty else {
            self.userMessage.value = "Please enter your password."
            return
        }
        
        // Start progress indicator
        updateLoadingStatus?(true)
        
        let userInfo = UserInfo(email: email, password: password)
        
        NetworkService.shared.authenticateUser(userInfo: userInfo) { [weak self] result in
            DispatchQueue.main.async {
                self?.updateLoadingStatus?(false)
                switch result {
                case .success(let tokenInfo):
                    if let accessTokenData = tokenInfo.accessToken.data(using: .utf8),
                       let refreshTokenData = tokenInfo.refreshToken.data(using: .utf8) {
                        self?.keychainHelper.save(accessTokenData, service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                        self?.keychainHelper.save(refreshTokenData, service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
                    }
                    self?.isAuthenticated.value = true
                case .failure(let error):
                    self?.userMessage.value = "Error occurred: \(error.localizedDescription)"
                }
            }
        }
    }
}

