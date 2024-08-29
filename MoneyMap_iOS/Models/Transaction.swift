//
//  Transaction.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 06/04/24.
//

import Foundation

struct Transaction: Decodable {
    let id: Int
    let type: TransactionType
    let description: String
    let date: String
    let userId: Int
    let amount: Int
}
