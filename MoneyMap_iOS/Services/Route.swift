//
//  Route.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 26/08/24.
//

import Foundation


enum Route{
    
    static let baseURL = "http://localhost:8082"
    
    case createNewUser
    case authenticateUser
    case getUserDetails
    case updateUserProfilePic
    case getAllTransations
    case createNewTransaction
    case deleteTransaction(id:Int)
    case logout
    var description:String {
        
        switch self{
        case .createNewUser :
            return "/register"
        case .authenticateUser :
            return "/login"
        case .getUserDetails:
            return "/user/get"
        case .updateUserProfilePic:
            return "/user/update-profileImageData"
        case .getAllTransations:
            return "/transaction/get-all"
        case .createNewTransaction:
            return "/transaction/create"
        case .deleteTransaction(let id):
            return "/transaction/delete/\(id)"
        case .logout:
            return "/logout"
        }
    
        
    }
    
    
    
}
