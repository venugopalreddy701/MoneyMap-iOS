//
//  HomeScreenViewController.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 09/03/24.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let profileVM = ProfileViewModel()
    
     let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private let editProfileImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile Picture", for: .normal)
        button.layer.borderColor = UIColor(red: 65/255, green: 113/255, blue: 242/255, alpha: 0).cgColor
        button.backgroundColor = UIColor.systemBackground
        button.setTitleColor(UIColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email ID"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.textAlignment = .center
        textField.textColor = .blue
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.borderColor = UIColor(red: 65/255, green: 113/255, blue: 242/255, alpha: 0).cgColor
        button.backgroundColor = UIColor.systemBackground
        button.setTitleColor(UIColor.red, for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.layer.borderColor = UIColor(red: 65/255, green: 113/255, blue: 242/255, alpha: 0).cgColor
        button.backgroundColor = UIColor.systemBackground
        button.setTitleColor(UIColor.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let refreshButton: UIBarButtonItem = {
        let Button = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        Button.tintColor = UIColor.blue
        return Button
    }()
    
    
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
        profileVM.loadUserDetails()
    }
        
    
    private func setUpUI(){
        
        title = profileVM.title
        
        view.backgroundColor = .white
        view.addSubview(profileImageView)
        view.addSubview(editProfileImageButton)
        view.addSubview(emailTextField)
        view.addSubview(activityIndicator)
        view.addSubview(saveButton)
        view.addSubview(signOutButton)
    
        navigationItem.rightBarButtonItem = refreshButton
        refreshButton.target = self
        refreshButton.action = #selector(loadUserProfile)
        
        signOutButton.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        editProfileImageButton.addTarget(self, action: #selector(chooseProfileImageButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveProfilePic), for: .touchUpInside)
        
        
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: LayoutConstants.imageTopMargin),
            profileImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.imageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.imageSize),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
            
        NSLayoutConstraint.activate([
            editProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: LayoutConstants.buttonTopMargin),
            editProfileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
            
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding)])
        
        
            
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: editProfileImageButton.bottomAnchor, constant: 35),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding)])
            
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 35),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding)])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    
         
    }
    
    @objc private func logoutUser(){
        
        profileVM.logoutUser()
    }
    
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func bindViewModel() {

        profileVM.userMessage.bind { [weak self] message in
            guard let self = self else { return }
            
            if let message = message {
                self.showAlert(message: message)
            }
        }
        
        //setup closure to update the indicator
        profileVM.updateLoadingStatus = { [weak self] isLoading in
            guard let self = self else { return }
            
            if isLoading {
                self.activityIndicator.startAnimating()
                self.view.isUserInteractionEnabled = false
                self.navigationController?.navigationBar.isUserInteractionEnabled = false
            } else {
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
            }
        }
        
        //for login redirect
        profileVM.isAuthenticated.bind{ [weak self] state in
        
            switch state {
             case false :
                self?.redirectToLogin()
             default:
                    break
                }
          
          }
        
        profileVM.userEmail.bind { [weak self] email in
            if let email = email {
                self?.emailTextField.text = email
            }
        }
        
        profileVM.profilePicData.bind{ [weak self] profileData in
            
            if let profileData = profileData {
                self?.profileImageView.image = String.fromBase64String(profileData)
            }
            
            
            
        }
        
       
    }
    
    @objc private func loadUserProfile(){
        profileVM.loadUserDetails()
    }
    
    private func redirectToLogin() {
 
        print("redirect to login event triggered in ProfileVC")
        let navVC = UINavigationController(rootViewController: LoginViewController())
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: {
            self.navigationController?.popViewController(animated: false)
        })
      
    }
    
    
    // Make UIImage view round during load by runtime calculations
       override func viewWillLayoutSubviews() {
           profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
       }
    
    
    @objc private func chooseProfileImageButtonTapped() {
        saveButton.isHidden = false
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @objc private func saveProfilePic()
    {
        profileVM.saveNewProfilePic(profilePicture: profileImageView.image)
    }
    
    
    
    
}

