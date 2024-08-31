//
//  HomeViewModel.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 09/03/24.
//

import UIKit

final class ProfileViewModel {
    
    let title = "Profile"
    
    var userMessage: Observable<String?> = Observable(nil)
    var isAuthenticated: Observable<Bool> = Observable(true)
    var updateLoadingStatus: ((Bool) -> Void)?
    
    private let keychainHelper = KeychainHelper.standard
    
    var userEmail: Observable<String?> = Observable(nil)
    var profilePicData: Observable<String?> = Observable(nil)
    
    func loadUserDetails() {
        // Start progress indicator
        updateLoadingStatus?(true)
        
        NetworkService.shared.getUserDetails { [weak self] (result: Result<UserProfileInfo, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Close progress indicator
                self.updateLoadingStatus?(false)
                
                switch result {
                case .success(let userProfileInfo):
                    self.userEmail.value = userProfileInfo.email
                    self.profilePicData.value = userProfileInfo.profile
                    self.userMessage.value = "User details fetched successfully"
                case .failure(let error):
                    self.isAuthenticated.value = false
                    self.userMessage.value = "Invalid login: Error occurred - \(error.localizedDescription)"
                }
            }
        }
    }
    
    func logoutUser() {
        // Start progress indicator
        updateLoadingStatus?(true)
        
        NetworkService.shared.logOut { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Close progress indicator
                self.updateLoadingStatus?(false)
                
                switch result {
                case .success(_):
                    self.userMessage.value = "Logout successful"
                    self.isAuthenticated.value = false
                case .failure(let error):
                    self.userMessage.value = "Logout failed: Error occurred - \(error.localizedDescription)"
                }
            }
        }
    }
    
    func saveNewProfilePic(profilePicture: UIImage?) {
        // Start progress indicator
        updateLoadingStatus?(true)
        
        guard let profilePicture = profilePicture else {
            self.userMessage.value = "Profile picture error"
            return
        }
        
        DispatchQueue.global().async {
            let profilePictureString = profilePicture.toBase64String()
            
            NetworkService.shared.saveNewProfilePic(profilePicString: profilePictureString!) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.updateLoadingStatus?(false)
                    switch result {
                    case .success(_):
                        self.userMessage.value = "Profile picture updated successfully"
                    case .failure(let error):
                        self.userMessage.value = "Error occurred: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

