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
    
    func loginUser(email: String, password: String){
        
        DispatchQueue.global().async {
            
            AuthWebService().authenticateUser(email: email, password: password){[weak self] result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Success inside switch")
                        self?.userMessage.value = "Login successfully"
                    case .failure(let error):
                        self?.userMessage.value = "Error occurred: \(error.localizedDescription)"
                    }
                    
                }
                
            }
        }
        
        
    }
    
    
}
