//
//  TransactionList.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 29/08/24.
//

import Foundation

struct TransactionList: Decodable {
    
    let transactionList: [Transaction]
    
    /// Custom initializer to manually decode the array from JSON
    init(from decoder: Decoder) throws {
        // Create a container keyed by custom keys
        let container = try decoder.singleValueContainer()
        // Decode the array of transactions directly
        self.transactionList = try container.decode([Transaction].self)
    }
    
}

