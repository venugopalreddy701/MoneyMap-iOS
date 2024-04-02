//
//  HomeViewModel.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 09/03/24.
//

import Foundation

final class HomeViewModel{
    
    let title = "Home"
    
    var userMessage: Observable<String?> = Observable(nil)
    
    var isAuthenticated: Observable<Bool?> = Observable(true)
    
    var updateLoadingStatus: ((Bool) -> Void)?
    
    private let keychainHelper = KeychainHelper.standard
    
    var userEmail:Observable<String?> = Observable(nil)
    
    
    
    func loadUserDetails(){
        //start progress indicator
        updateLoadingStatus?(true)
        
        UserWebService.getUserDetails(){[weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                //close progress indicator
                self.updateLoadingStatus?(false)
                
                switch result {
                case .success(let email):
                    self.userEmail.value = email
                    self.userMessage.value = "User Details fetch successfully"
                case .failure(let error):
                    self.isAuthenticated.value = false
                    self.userMessage.value = "Invalid login: Error occurred - \(error.localizedDescription)"
                }
                self.updateLoadingStatus?(false)
            }
        }
     
    }
    
    
    
  
}

