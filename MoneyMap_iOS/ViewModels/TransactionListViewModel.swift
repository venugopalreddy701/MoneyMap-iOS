//
//  TransactionListViewModel.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 04/04/24.
//

import Foundation

final class TransactionListViewModel{
    
    let title = "Transactions"
    
    var isAuthenticated: Observable<Bool?> = Observable(true)
    
    var updateLoadingStatus: ((Bool) -> Void)?
    
    private var transactionViewModels = [TransactionViewModel]()
    
    var earnedTotal:Observable<Int?> = Observable(0)
    
    var spentTotal:Observable<Int?> = Observable(0)
    
    
    func numberOfRows(_ section: Int) -> Int {
        return transactionViewModels.count
    }
    
    func modelAt(_ index: Int) -> TransactionViewModel {
        return transactionViewModels[index]
    }
    
    
    func fetchTransactions(completion: @escaping () -> Void) {
        
        //start progress indicator
        updateLoadingStatus?(true)
        
            TransactionWebService.getAllTransactions { [weak self] result in
                
                self!.updateLoadingStatus?(false)
                
                switch result {
                case .success(let transactions):
                    self?.transactionViewModels = transactions.map { transaction in
                        TransactionViewModel(id:transaction.id,
                                             type: transaction.type,
                                             description: transaction.description,
                                             date: transaction.date,
                                             amount: transaction.amount)
                        
                    }
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isAuthenticated.value = false
                    completion()
                }
                
            }
        }
    
    func calculateEarningsAndSpentValues(){
        
            var earnings: Int = 0
            var spent:Int = 0
            
            for transactionViewModel in self.transactionViewModels {
                if transactionViewModel.type == TransactionType.earned {
                    earnings = earnings + transactionViewModel.amount
                }
                if transactionViewModel.type == TransactionType.spent {
                    spent = spent + transactionViewModel.amount
                }
                
            }
            print("Inside calculate func: \(earnings) \(spent) ")
        
        DispatchQueue.main.async {
            self.earnedTotal.value = earnings
            self.spentTotal.value = spent
        }
    
        
    }
    
    func removeTransaction(at index:Int){
        
        //start progress indicator
        updateLoadingStatus?(true)
        
        let idToDelete = transactionViewModels[index].id
        print("Id to delete:\(idToDelete)")
        transactionViewModels.remove(at: index)
 
        
        TransactionWebService.removeTransaction(id:idToDelete){ [weak self] result in
            self!.updateLoadingStatus?(false)
            switch result {
            case .success(_):
                   print("Successfully deleted transaction")
                
            case .failure(let error):
                print(error.localizedDescription)
                self?.isAuthenticated.value = false
              
            }
           
            
        }
        
       self.calculateEarningsAndSpentValues()
       
        
    }
    
    
}

final class TransactionViewModel {
    
    let id: Int
    let type: TransactionType
    let description: String
    let date: String
    let amount: Int
    
    init(id:Int,type: TransactionType, description: String, date: String, amount: Int) {
        self.id = id
        self.type = type
        self.description = description
        self.date = date
        self.amount = amount
    }
    
    
}
