//
//  TransactionListViewModel.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 04/04/24.
//

import Foundation

final class TransactionListViewModel {
    
    let title = "Transactions"
    
    var isAuthenticated: Observable<Bool> = Observable(true)
    var updateLoadingStatus: ((Bool) -> Void)?
    
    private var transactionViewModels = [TransactionViewModel]()
    
    var earnedTotal: Observable<Int> = Observable(0)
    var spentTotal: Observable<Int> = Observable(0)
    
    func numberOfRows(_ section: Int) -> Int {
        return transactionViewModels.count
    }
    
    func modelAt(_ index: Int) -> TransactionViewModel {
        return transactionViewModels[index]
    }
    
    func fetchTransactions(completion: @escaping () -> Void) {
        // Start progress indicator
        updateLoadingStatus?(true)
        
        NetworkService.shared.getAllTransactions { [weak self] result in
            self?.updateLoadingStatus?(false)
            
            switch result {
            case .success(let transactionList):
                let transactions = transactionList.transactionList
                self?.transactionViewModels = transactions.map { transaction in
                    TransactionViewModel(
                        id: transaction.id,
                        type: transaction.type,
                        description: transaction.description,
                        date: transaction.date,
                        amount: transaction.amount
                    )
                }
                
            case .failure:
                self?.isAuthenticated.value = false
            }
            completion()
        }
    }
    
    func calculateEarningsAndSpentValues() {
        var earnings: Int = 0
        var spent: Int = 0
        
        for transactionViewModel in self.transactionViewModels {
            if transactionViewModel.type == .earned {
                earnings += transactionViewModel.amount
            } else if transactionViewModel.type == .spent {
                spent += transactionViewModel.amount
            }
        }
        
        DispatchQueue.main.async {
            self.earnedTotal.value = earnings
            self.spentTotal.value = spent
        }
    }
    
    func removeTransaction(at index: Int) {
        // Start progress indicator
        updateLoadingStatus?(true)
        
        let idToDelete = transactionViewModels[index].id
        transactionViewModels.remove(at: index)
        
        NetworkService.shared.removeTransaction(id: idToDelete) { [weak self] result in
            guard let self = self else { return }
            self.updateLoadingStatus?(false)
            
            switch result {
            case .success:
                break
            case .failure:
                self.isAuthenticated.value = false
            }
        }
        
        self.calculateEarningsAndSpentValues()
    }
}

final class TransactionViewModel {
    
    let id: Int
    let type: TransactionType
    let description: String
    let dateString: String
    let amount: Int
    
    init(id: Int, type: TransactionType, description: String, date: String, amount: Int) {
        self.id = id
        self.type = type
        self.description = description
        self.dateString = date
        self.amount = amount
    }
}

