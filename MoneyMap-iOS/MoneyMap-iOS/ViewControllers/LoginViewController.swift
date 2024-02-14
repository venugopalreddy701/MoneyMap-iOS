//
//  ViewController.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 03/02/24.
//

import UIKit

class LoginViewController: UIViewController {

    private let emailTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Email ID"
            textField.borderStyle = .roundedRect
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
            button.layer.borderColor = CGColor(red: 65, green: 113, blue: 242, alpha: 0)
            button.backgroundColor = UIColor(red: 0/255, green: 204/255, blue: 0/255, alpha: 1.0)
            button.setTitleColor(UIColor.white, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    
    private let registerButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Create Account", for: .normal)
            button.layer.borderColor = CGColor(red: 65, green: 113, blue: 242, alpha: 0)
            button.backgroundColor = UIColor(red: 26/255, green: 117/255, blue: 255/255, alpha: 1.0)
            button.setTitleColor(UIColor.white, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor =  .white
        setUpUI()
    }

    
    
    private func setUpUI(){
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
                   emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                   emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                   
                   passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
                   passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                   
                   loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
                   loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                   
                   
                   registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
                   registerButton.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 20),
                   registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
                  
               ])
    }
    
    @objc private func loginButtonTapped(_ sender: UIButton) {
            
            print("Login Button Tapped")
        }
    
    
    @objc private func registerButtonTapped(_ sender: UIButton) {
        
            print("Register Button Tapped")
            let CreateAccountViewController = CreateAccountViewController()
            navigationController?.pushViewController(CreateAccountViewController, animated: true)
        
        
        }
    
    

}

