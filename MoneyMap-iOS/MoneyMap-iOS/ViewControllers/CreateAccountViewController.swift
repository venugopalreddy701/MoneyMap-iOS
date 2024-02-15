//
//  CreateAccountViewController.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 07/02/24.
//
import UIKit

class CreateAccountViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = createAccountVM.title
        view.backgroundColor = .white
        setUpUI()
        bindViewModel()
    }
    
    func bindViewModel() {
        createAccountVM.successMessage.bind { [weak self] message in
            if let message = message {
                self?.showAlert(message: message)
            }
        }
        
        createAccountVM.errorMessage.bind { [weak self] message in
            if let message = message {
                self?.showAlert(message: message)
            }
        }
        
        createAccountVM.validationMessage.bind { [weak self] message in
            if let message = message {
                self?.showAlert(message: message)
            }
        }
    }
    
    // Make UIImage view round during load by runtime calculations
    override func viewWillLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
    }
    
    func setUpUI() {
        editProfileImageButton.addTarget(self, action: #selector(chooseProfileImageButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        view.addSubview(profileImageView)
        view.addSubview(editProfileImageButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        editProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        editProfileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: editProfileImageButton.bottomAnchor, constant: 30).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
        let email = emailTextField.text
        let password = passwordTextField.text
        let reenteredPassword = confirmPasswordTextField.text
        let profilePicture = profileImageView.image
        
        createAccountVM.createNewUser(email: email!, password: password!, reenteredPassword: reenteredPassword!, profilePicture: profilePicture)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
