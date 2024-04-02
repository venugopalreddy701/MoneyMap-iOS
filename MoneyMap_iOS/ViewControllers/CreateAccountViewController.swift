//
//  CreateAccountViewController.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 07/02/24.
//

import UIKit

final class CreateAccountViewController: UIViewController {
    
    private let createAccountVM = CreateAccountViewModel()
    
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Re-Enter Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.layer.borderColor = UIColor(red: 65/255, green: 113/255, blue: 242/255, alpha: 0).cgColor
        button.backgroundColor = UIColor(red: 26/255, green: 117/255, blue: 255/255, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
    }
    
    
    func bindViewModel() {

        createAccountVM.userMessage.bind { [weak self] message in
            if let message = message {
                self?.showAlert(message: message)
            }
        }
        
        //setup closure to update the indicator
        createAccountVM.updateLoadingStatus = { [weak self] isLoading in
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
        
        
    }
    
    // Make UIImage view round during load by runtime calculations
    override func viewWillLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
    }
    
    func setUpUI() {
        
        title = createAccountVM.title

        view.backgroundColor = .white

        editProfileImageButton.addTarget(self, action: #selector(chooseProfileImageButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        view.addSubview(profileImageView)
        view.addSubview(editProfileImageButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // Constraints for profileImageView
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstants.imageTopMargin),
            profileImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.imageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.imageSize),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
            
        NSLayoutConstraint.activate([
            // Constraints for editProfileImageButton
            editProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: LayoutConstants.buttonTopMargin),
            editProfileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
            
        NSLayoutConstraint.activate([
            // Constraints for emailTextField
            emailTextField.topAnchor.constraint(equalTo: editProfileImageButton.bottomAnchor, constant: LayoutConstants.textFieldTopMargin),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding)])
            
        NSLayoutConstraint.activate([
            // Constraints for passwordTextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: LayoutConstants.textFieldSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding)])
            
        NSLayoutConstraint.activate([
            // Constraints for confirmPasswordTextField
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: LayoutConstants.textFieldSpacing),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding)])
            
        NSLayoutConstraint.activate([
            // Constraints for registerButton
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: LayoutConstants.textFieldSpacing),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding),
            registerButton.heightAnchor.constraint(equalToConstant: LayoutConstants.buttonHeight)])
            
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        emailTextField.returnKeyType = .done
        passwordTextField.returnKeyType = .done
        confirmPasswordTextField.returnKeyType = .done
        
        // Quit from keyboard when other view is pressed
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func chooseProfileImageButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func registerButtonTapped(_ sender: UIButton) {
       guard let email = emailTextField.text, !email.isEmpty else {
           showAlert(message: "Please enter your email.")
           return
         }
    
       guard let password = passwordTextField.text, !password.isEmpty else {
           showAlert(message: "Please enter your password.")
           return
         }
    
       guard let reenteredPassword = confirmPasswordTextField.text, !reenteredPassword.isEmpty else {
           showAlert(message: "Please re-enter your password.")
           return
         }
        let profilePicture = profileImageView.image
        
        createAccountVM.createNewUser(email: email, password: password, reenteredPassword: reenteredPassword, profilePicture: profilePicture)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

