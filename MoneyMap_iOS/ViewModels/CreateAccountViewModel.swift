//
//  createAccountViewModel.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 10/02/24.
//
import UIKit

final class CreateAccountViewModel {
    
    let title = "Create Account"
    
    var userMessage: Observable<String?> = Observable(nil)
    
    var updateLoadingStatus: ((Bool) -> Void)?
    
    func createNewUser(email: String, password: String, reenteredPassword: String, profilePicture: UIImage?) {
           
        if !validateInputs(email: email, password: password, reenteredPassword: reenteredPassword){
            return
        }
        
        //start progress indicator
        updateLoadingStatus?(true)

  
           DispatchQueue.global().async {
               let profilePictureString = profilePicture?.toBase64String()
               let userToCreate = User(email: email, password: password, profileImageData: profilePictureString ?? "")
              
               UserWebService.createNewUser(userToCreate) { [weak self] result in
                   DispatchQueue.main.async {
                       self?.updateLoadingStatus?(false)
                       switch result {
                       case .success(_):
                           self?.userMessage.value = "User created successfully"
                       case .failure(let error):
                           self?.userMessage.value = "Error occurred: \(error.localizedDescription)"
                       }
                   }
               }
           }
       }
    
    
    
    private func validateInputs(email: String?, password: String?, reenteredPassword: String?) -> Bool {
            guard let email = email, !email.isEmpty,
                  let password = password, !password.isEmpty,
                  let reenteredPassword = reenteredPassword, !reenteredPassword.isEmpty
                 else {
                userMessage.value = "Please make sure all fields are filled and a profile picture is selected."
                return false
            }
            
            if password != reenteredPassword {
                userMessage.value = "Please make sure password fields match"
                return false
            }
            
            return true
    }
    
  
}




