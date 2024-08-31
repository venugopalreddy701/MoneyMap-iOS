//
//  AddTransactionViewModel.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 07/04/24.
//

import Foundation

final class AddTransactionViewModel {
    
    let title = "Add Transaction"
    var userMessage: Observable<String?> = Observable(nil)
    
    func addTransaction(description: String, amount: Int, transactionType: TransactionType) {
        
        let addTransactionInfo = AddTransactionInfo(description: description, amount: amount, type: transactionType.rawValue)
        
        NetworkService.shared.addTransaction(description: description, amount: amount, transactionType: transactionType) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.userMessage.value = "Transaction added successfully"
                case .failure(let error):
                    self?.userMessage.value = "Error occurred: \(error.localizedDescription)"
                }
            }
        }
    }
}

