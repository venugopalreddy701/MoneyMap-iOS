//
//  AddTransactionViewController.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 07/04/24.
//

import UIKit

final class AddTransactionViewController: UIViewController {
    
    private let addTransactionVM = AddTransactionViewModel()
    
    var onTransactionAdded: (() -> Void)?
    
    private let transactionToggleButton: UISegmentedControl = {
        let items = ["earned", "spent"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0 // Default selected index
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Description"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Amount"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.layer.borderColor = UIColor(red: 65/255, green: 113/255, blue: 242/255, alpha: 0).cgColor
        button.backgroundColor = UIColor(red: 26/255, green: 117/255, blue: 255/255, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = addTransactionVM.title
        
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = cancelButton
        
        addTransactionButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        
        view.addSubview(transactionToggleButton)
        view.addSubview(descriptionTextField)
        view.addSubview(amountTextField)
        view.addSubview(addTransactionButton)
        
        NSLayoutConstraint.activate([
            transactionToggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            transactionToggleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            transactionToggleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            transactionToggleButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextField.topAnchor.constraint(equalTo: transactionToggleButton.bottomAnchor, constant: 30),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 30),
            amountTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            amountTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            amountTextField.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            addTransactionButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 30),
            addTransactionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            addTransactionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addTransaction() {
        guard let description = descriptionTextField.text, !description.isEmpty else {
            showAlert(message: "Please enter the description of the Transaction")
            return
        }
        
        guard let amountText = amountTextField.text, !amountText.isEmpty, let amount = Int(amountText) else {
            showAlert(message: "Please enter the amount of the Transaction")
            return
        }
        
        let transactionType: TransactionType = transactionToggleButton.selectedSegmentIndex == 0 ? .earned : .spent
        
        DispatchQueue.global().async { [self] in
            addTransactionVM.addTransaction(description: description, amount: amount, transactionType: transactionType)
            onTransactionAdded?()
        }
    }
    
    private func bindViewModel() {
        addTransactionVM.userMessage.bind { [weak self] message in
            if let message = message {
                self?.showAlert(message: message)
            }
        }
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

