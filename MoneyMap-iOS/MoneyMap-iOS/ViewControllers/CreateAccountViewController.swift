//
//  CreateAccountViewController.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 07/02/24.
//

import Foundation
import UIKit

class CreateAccountViewController : UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    private var createAccountVM = CreateAccountViewModel()
    
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
    
    let EditProfileImageButton:UIButton = {
       
        let button = UIButton()
        button.setTitle("Edit Profile Picture", for: .normal)
        button.addTarget(self, action: #selector(chooseProfileImageButtonTapped), for: .touchUpInside)
        button.layer.borderColor = CGColor(red: 65, green: 113, blue: 242, alpha: 0)
        button.backgroundColor = UIColor.systemBackground
        button.setTitleColor(UIColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
 
    
    
    let emailTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Email ID"
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.autocapitalizationType = .none
            return textField
        }()
    
    let passwordTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Enter Password"
            textField.isSecureTextEntry = true
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
    
    let confirmPasswordTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Re-Enter Password"
            textField.isSecureTextEntry = true
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
    
    let registerButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Register", for: .normal)
            button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
            button.layer.borderColor = CGColor(red: 65, green: 113, blue: 242, alpha: 0)
            button.backgroundColor = UIColor(red: 26/255, green: 117/255, blue: 255/255, alpha: 1.0)
            button.setTitleColor(UIColor.white, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor =  .white
        setUpUI()
    }
    
   
    // Make UIImage view round during load by runtime calclations
    override func viewWillLayoutSubviews() {
    
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        
    }
    
    
    func setUpUI(){
        
        view.addSubview(profileImageView)
        view.addSubview(EditProfileImageButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
        
        
        
        NSLayoutConstraint.activate([
                   
                   profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 40),
                   profileImageView.widthAnchor.constraint(equalToConstant: 200),
                   profileImageView.heightAnchor.constraint(equalToConstant: 200),
                   profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   
                   EditProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 10),
                   EditProfileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   
            
                   emailTextField.topAnchor.constraint(equalTo: EditProfileImageButton.bottomAnchor, constant: 30),
                   emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                   
                   passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
                   passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                   
                   confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
                   confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                   
                   registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
                   registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                   registerButton.heightAnchor.constraint(equalToConstant: 40)
                  
               ])
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        emailTextField.returnKeyType = .done
        passwordTextField.returnKeyType = .done
        confirmPasswordTextField.returnKeyType = .done
        
        //quit from keyboard when other view is pressed
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Hide the keyboard when return key is pressed
            textField.resignFirstResponder()
            return true
        }
    
    
    
    @objc func chooseProfileImageButtonTapped() {
           let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.sourceType = .photoLibrary
           present(imagePickerController, animated: true, completion: nil)
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               profileImageView.image = selectedImage
           }
           picker.dismiss(animated: true, completion: nil)
           
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
    
    
   
    
    @objc func registerButtonTapped(_ sender: UIButton) {
        
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,let reenteredpassword = confirmPasswordTextField.text, !reenteredpassword.isEmpty,
              let profilePicture = profileImageView.image else {
            showAlert(message: "Please make sure all fields are filled and a profile picture is selected.")
            return
        }
        
        if password != reenteredpassword {
            showAlert(message: "Please make sure password fields match")
            return
            
        }
        
        if password.count <= 8 {
            showAlert(message: "Please enter the strong password(>8 characters)")
            return
        }
        
        
        
        let profilePictureString = ImageConverter.convertImageToBase64String(img: profilePicture)
        
        createAccountVM.createNewUser(email: email, password: password, profilePictureString: profilePictureString) { [weak self] result in
            switch result {
                case .success(_):
                    self?.showAlert(message: "User created successfully")
                case .failure(let error):
                    self?.showAlert(message: "Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    
    func showAlert(message: String) {
            let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    
    
  
    
}
