//
//  HomeViewModel.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 09/03/24.
//

import UIKit

final class ProfileViewModel{
    
    let title = "Profile"
    
    var userMessage: Observable<String?> = Observable(nil)
    
    var isAuthenticated: Observable<Bool?> = Observable(true)
    
    var updateLoadingStatus: ((Bool) -> Void)?
    
    private let keychainHelper = KeychainHelper.standard
    
    var userEmail:Observable<String?> = Observable(nil)
    
    var profilePicData:Observable<String?> = Observable(nil)
    
    
    
    func loadUserDetails(){
        //start progress indicator
        updateLoadingStatus?(true)
        
        UserWebService.getUserDetails(){[weak self] (result: Result<UserProfileInfo, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                //close progress indicator
                self.updateLoadingStatus?(false)
                
                switch result {
                case .success(let userProfileInfo):
                    self.userEmail.value = userProfileInfo.email
                    self.profilePicData.value = userProfileInfo.profile
                    self.userMessage.value = "User Details fetch successfully"
                case .failure(let error):
                    self.isAuthenticated.value = false
                    self.userMessage.value = "Invalid login: Error occurred - \(error.localizedDescription)"
                }
                self.updateLoadingStatus?(false)
            }
        }
     
    }
    
    func logoutUser(){
        //start progress indicator
        updateLoadingStatus?(true)
        
        UserWebService.logoutUser(){[weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                //close progress indicator
                self.updateLoadingStatus?(false)
                
                switch result {
                case .success(_):
                    self.userMessage.value = "Log out successfull"
                    self.isAuthenticated.value = false
                case .failure(let error):
                    
                    self.userMessage.value = "Invalid login: Error occurred - \(error.localizedDescription)"
                }
                self.updateLoadingStatus?(false)
            }
        }
        
        
        
    }
    
    
    func saveNewProfilePic(profilePicture: UIImage?){
        //start progress indicator
        updateLoadingStatus?(true)
        
        guard let profilePicture = profilePicture else
        {
            self.userMessage.value = "Pic error"
            return
        }
        
        DispatchQueue.global().async {
            
            let profilePictureString = profilePicture.toBase64String()
            
            UserWebService.saveNewProfilePic(profilePicString: profilePictureString!){[weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    //close progress indicator
                    self.updateLoadingStatus?(false)
                    
                    switch result {
                    case .success(_):
                        self.userMessage.value = "Image SuccessFully Updated"
                        self.isAuthenticated.value = false
                    case .failure(let error):
                        
                        self.userMessage.value = "Invalid login: Error occurred - \(error.localizedDescription)"
                    }
                    self.updateLoadingStatus?(false)
                }
            }
        }
        
        
        
        
    }
    
    
    
  
}

