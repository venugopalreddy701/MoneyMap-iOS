//
//  AuthWebService.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 26/02/24.
//

import Foundation

final class AuthWebService {
    
    private let baseURL = "http://localhost:8082"
    private let keychainHelper = KeychainHelper.standard
    
    func authenticateUser(userInfo: UserInfo,completion: @escaping (Result<TokenInfo, Error>) -> Void)
    {
        guard let urlString = URL(string: baseURL + "/login") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        let requestBody: [String: String] = ["email": userInfo.email, "password": userInfo.password]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "JSON Serialization Error", code: -1, userInfo: nil)))
            return
        }
        
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode){
                if let data = data {
                        do {
                            let json = try JSONDecoder().decode(TokenInfo.self, from: data)
                            
                            self.keychainHelper.save(json.accessToken, service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                            self.keychainHelper.save(json.refreshToken, service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
                            
                            completion(.success(json))
                        } catch {
                            completion(.failure(error))
                        }
                }
            }
            else
            {
                completion(.failure(NSError(domain: "Invalid response", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)))
                return
            }
            
        }.resume()
        
    }
    
  
    
}

