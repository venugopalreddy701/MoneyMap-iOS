//
//  AppError.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 26/08/24.
//

import Foundation

enum AppError: LocalizedError {

    case errorDecoding
    case unknownError
    case invalidUrl
    case serverError(String)
    case loginInRedirect
    case noKeysFound
    case errorWhileRefreshingAccessToken

    var errorDescription: String? {
        switch self {
        case .errorDecoding:
            return "Response could not be decoded"
        case .unknownError:
            return "Bruhhh!!! I have no idea what go on"
        case .invalidUrl:
            return "HEYYY!!! Give me a valid URL"
        case .serverError(let error):
            return error
        case .loginInRedirect:
            return "Login in again"
        case .noKeysFound:
            return "No keys found in keychain"
        case .errorWhileRefreshingAccessToken:
            return "Error while refreshing access token"
        }
    }
}

