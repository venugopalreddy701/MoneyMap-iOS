//
//  createAccountViewModel.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 10/02/24.
//

import Foundation


class CreateAccountViewModel {
    
    func createNewUser(email: String, password: String, profilePictureString: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let userToCreate = User(email: email, password: password, profileData: profilePictureString)
        
        DispatchQueue.global().async {
            UserWebService.createNewUser(userToCreate) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}


