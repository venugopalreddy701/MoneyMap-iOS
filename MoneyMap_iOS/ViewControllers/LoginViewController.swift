//
//  LoginViewController.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 03/02/24.
//

import UIKit

final class LoginViewController: UIViewController {

    private let loginVM = LoginViewModel()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email ID"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.layer.borderColor = UIColor(red: 65/255, green: 113/255, blue: 242/255, alpha: 0).cgColor
        button.backgroundColor = UIColor(red: 84/255, green: 145/255, blue: 77/255, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
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
    
  
    private func setUpUI(){
        
        title = loginVM.title
        
        view.backgroundColor = .white
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // Constraints for emailTextField
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.textFieldTopMargin),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding),
            
            // Constraints for passwordTextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: LayoutConstants.textFieldTopMargin),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding),
            
            // Constraints for loginButton
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: LayoutConstants.buttonTopMargin),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.buttonHorizontalPadding),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.buttonHorizontalPadding),
            
            // Constraints for registerButton
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: LayoutConstants.buttonTopMargin),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.buttonHorizontalPadding),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.buttonHorizontalPadding),
            
            activityIndicator.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
       
       
    }
    
   
    
    @objc private func loginButtonTapped(_ sender: UIButton) {
        
        loginVM.loginUser(email: emailTextField.text, password: passwordTextField.text)
     
    }
    
    
    @objc private func registerButtonTapped(_ sender: UIButton) {
        
        let createAccountViewController = CreateAccountViewController()
        navigationController?.pushViewController(createAccountViewController, animated: true)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func bindViewModel() {

        loginVM.userMessage.bind { [weak self] message in
            if let message = message {
                self?.showAlert(message: message)
            }
        }
        
        //setup closure to update the indicator
        loginVM.updateLoadingStatus = { [weak self] isLoading in
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
        loginVM.isAuthenticated.bind{ [weak self] state in
        
            switch state {
             case true :
                self?.redirectToHome()
             default:
                break
              }
          
          }
        
       
    }
    
    
    
    private func redirectToHome() {

        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC,animated: true)
        
        
    }
    
    
    
    
}


