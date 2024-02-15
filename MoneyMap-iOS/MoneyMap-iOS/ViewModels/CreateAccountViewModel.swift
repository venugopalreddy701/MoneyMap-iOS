//
//  createAccountViewModel.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 10/02/24.
//
import UIKit

class CreateAccountViewModel {
    
    let title = "Create Account"
    
    var successMessage: Observable<String?> = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    var validationMessage: Observable<String?> = Observable(nil)
    
    func createNewUser(email: String, password: String, reenteredPassword: String, profilePicture: UIImage?) {
           
        if  !validateInputs(email: email, password: password, reenteredPassword: reenteredPassword) {
            return
        }
  
           DispatchQueue.global().async {
               let profilePictureString = ImageConverter.convertImageToBase64String(img: profilePicture!)
               let userToCreate = User(email: email, password: password, profileImageData: profilePictureString)
               UserWebService.createNewUser(userToCreate) { [weak self] result in
                   DispatchQueue.main.async {
                       switch result {
                       case .success(_):
                           self?.successMessage.value = "User created successfully"
                       case .failure(let error):
                           self?.errorMessage.value = "Error occurred: \(error.localizedDescription)"
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
                validationMessage.value = "Please make sure all fields are filled and a profile picture is selected."
                return false
            }
            
            if password != reenteredPassword {
                validationMessage.value = "Please make sure password fields match"
                return false
            }
            
            return true
    }
    
  
}

class Observable<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping (T) -> Void) {
        self.listener = listener
        listener(value) // Trigger the listener with the initial value
    }
}



