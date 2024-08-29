//
//  AddTransactionInfo.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 09/04/24.
//

import Foundation

struct AddTransactionInfo: Encodable{
    let description: String
    let amount : Int
    let type:String
}
