//
//  HomeScreenViewController.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 09/03/24.
//

import UIKit

final class HomeScreenViewController: UIViewController {

    private let homeVM = HomeViewModel()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email ID"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        homeVM.loadUserDetails()
    }
        
    
    private func setUpUI(){
        
        title = homeVM.title
        
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(activityIndicator)
    
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.textFieldTopMargin),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.textFieldHorizontalPadding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.textFieldHorizontalPadding),
            
            activityIndicator.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    
         
    }
    
    
   
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func bindViewModel() {

        homeVM.userMessage.bind { [weak self] message in
            guard let self = self else { return }
            
            if let message = message {
                self.showAlert(message: message)
            }
        }
        
        //setup closure to update the indicator
        homeVM.updateLoadingStatus = { [weak self] isLoading in
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
        homeVM.isAuthenticated.bind{ [weak self] state in
        
            switch state {
             case false :
                self?.redirectToLogin()
             default:
                    break
                }
          
          }
        
        homeVM.userEmail.bind { [weak self] email in
            if let email = email {
                self?.emailTextField.text = email
            }
        }
        
       
    }
    
    
    
    private func redirectToLogin() {
      
        let loginViewController = LoginViewController()
        navigationController?.setViewControllers([loginViewController], animated: true)

        
    }
    
    
    
    
}

