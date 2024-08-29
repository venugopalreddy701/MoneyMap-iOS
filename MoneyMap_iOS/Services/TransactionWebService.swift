//
//  TransactionWebService.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 06/04/24.
//

import Foundation

final class TransactionWebService{
    
    private static let baseURL = "http://localhost:8082"
    
    private static let keychainHelper = KeychainHelper.standard
    
    static func getAllTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void){
        
        guard let urlString = URL(string: baseURL + "/transaction/get-all") else {
                    completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                    return
                }
        guard let accessToken = keychainHelper.readAsString(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount),
                      let refreshToken = keychainHelper.readAsString(service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
                else {
                    
                    completion(.failure(NSError(domain: "No values in Keychain, redirect to login", code: -1, userInfo: nil)))
                    return
                    
                }
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                        return
                    }

                    if httpResponse.statusCode == 401 {
                        // Access token has expired, refresh it
                        refreshAccessToken(refreshToken: refreshToken) { refreshResult in
                            switch refreshResult {
                            case .success(let newAccessToken):
                                // Update access token in keychain and retry the request
                                if let accessTokenData = newAccessToken.data(using: .utf8) {
                                    keychainHelper.save(accessTokenData, service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                                    getAllTransactions(completion: completion) // Retry the request
                                } else {
                                    completion(.failure(NSError(domain: "Failed to encode new access token", code: -1, userInfo: nil)))
                                }
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    } else if (200...299).contains(httpResponse.statusCode) {
                        // Request succeeded
                        guard let data = data,
                        let transactions = try? JSONDecoder().decode([Transaction].self, from: data)
                       else {
                            completion(.failure(NSError(domain: "Failed to parse JSON", code: -1, userInfo: nil)))
                                       return
                        }
                       
                        completion(.success(transactions))
                    } else {
                        // Other errors
                        completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
                    }
                }.resume()
        
        
        
    }
    
    
    static func refreshAccessToken(refreshToken: String, completion: @escaping (Result<String, Error>) -> Void) {
            guard let urlString = URL(string: baseURL + "/token/refresh") else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }

            var request = URLRequest(url: urlString)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["token": refreshToken]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    return
                }

                if httpResponse.statusCode == 401 {
                    // Refresh token has expired, redirect to login
                    keychainHelper.delete(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                    keychainHelper.delete(service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
                    completion(.failure(NSError(domain: "Refresh token expired, redirect to login", code: 401, userInfo: nil)))
                } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let newAccessToken = json["accessToken"] as? String {
                    // Got new access token
                    completion(.success(newAccessToken))
                } else {
                    // Other errors
                    completion(.failure(NSError(domain: "Failed to refresh token", code: httpResponse.statusCode, userInfo: nil)))
                }
            }.resume()
        }
        
    
    static func addTransaction(addTransactionInfo : AddTransactionInfo ,completion: @escaping (Result<Bool, Error>) -> Void){
       
        guard let urlString = URL(string: baseURL + "/transaction/create") else {
                    completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                    return
                }
        guard let accessToken = keychainHelper.readAsString(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount),
                      let refreshToken = keychainHelper.readAsString(service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
                else {
                    
                    completion(.failure(NSError(domain: "No values in Keychain, redirect to login", code: -1, userInfo: nil)))
                    return
                    
                }
        
        do {
            var request = URLRequest(url: urlString)
            let jsonData = try JSONEncoder().encode(addTransactionInfo)
            request.httpMethod = "POST"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    return
                }
                
                if httpResponse.statusCode == 401 {
                    // Access token has expired, refresh it
                    refreshAccessToken(refreshToken: refreshToken) { refreshResult in
                        switch refreshResult {
                        case .success(let newAccessToken):
                            // Update access token in keychain and retry the request
                            if let accessTokenData = newAccessToken.data(using: .utf8) {
                                keychainHelper.save(accessTokenData, service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                                addTransaction(addTransactionInfo: addTransactionInfo, completion: completion) // Retry the request
                            } else {
                                completion(.failure(NSError(domain: "Failed to encode new access token", code: -1, userInfo: nil)))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else if (200...299).contains(httpResponse.statusCode) {
                    // Request succeeded
                    completion(.success(true))
                } else {
                    // Other errors
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
                }
            }.resume()
        }catch{
            completion(.failure(NSError(domain: "Encoding Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode user data"])))
        }
        
      
        
    }
    
    
    static func removeTransaction(id:Int ,completion: @escaping (Result<Bool, Error>) -> Void )
    {
        guard let urlString = URL(string: baseURL + "/transaction/delete/"+String(id)) else {
                    completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                    return
                }
        guard let accessToken = keychainHelper.readAsString(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount),
                      let refreshToken = keychainHelper.readAsString(service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
                else {
                    
                    completion(.failure(NSError(domain: "No values in Keychain, redirect to login", code: -1, userInfo: nil)))
                    return
                    
                }
        do{
            var request = URLRequest(url: urlString)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    return
                }
                
                if httpResponse.statusCode == 401 {
                    // Access token has expired, refresh it
                    refreshAccessToken(refreshToken: refreshToken) { refreshResult in
                        switch refreshResult {
                        case .success(let newAccessToken):
                            // Update access token in keychain and retry the request
                            if let accessTokenData = newAccessToken.data(using: .utf8) {
                                keychainHelper.save(accessTokenData, service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                                removeTransaction(id: id, completion: completion) // Retry the request
                            } else {
                                completion(.failure(NSError(domain: "Failed to encode new access token", code: -1, userInfo: nil)))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else if (200...299).contains(httpResponse.statusCode) {
                    // Request succeeded
                    completion(.success(true))
                } else {
                    // Other errors
                    completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
                }
            }.resume()
            
        }
        catch{
            completion(.failure(NSError(domain: "Encoding Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode user data"])))
        }
        
    }
    
    
    
}
