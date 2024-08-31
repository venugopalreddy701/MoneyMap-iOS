//
//  NetworkService.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 26/08/24.
//

import Foundation

/// Generic Network layer to create Request and handle Response
struct NetworkService {

    static let shared = NetworkService()
    
    private let keychainHelper = KeychainHelper.standard
    
    private init() {}
    
    
    
    private func request<T: Decodable>(
        route: Route,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, Error>) -> Void,
        downloadTokens: Bool,
        withBearerToken: Bool
    ) {
        guard var request = createRequest(route: route, method: method, parameters: parameters) else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        if withBearerToken {
            let token = keychainHelper.readAsString(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount) ?? "default"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                return
            }
            
            var retry = 0
            if httpResponse.statusCode == 401 && withBearerToken {
                retry = 1
                guard let refreshToken = keychainHelper.readAsString(service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount) else {
                    completion(.failure(AppError.loginInRedirect))
                    return
                }
                
                refreshAccessToken(refreshToken: refreshToken) { refreshResult in
                    switch refreshResult {
                    case .success(let newAccessToken):
                        keychainHelper.save(newAccessToken.data(using: .utf8)!, service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                        self.request(route: route, method: method, parameters: parameters, completion: completion, downloadTokens: downloadTokens, withBearerToken: withBearerToken)
                    case .failure:
                        completion(.failure(AppError.errorWhileRefreshingAccessToken))
                    }
                }
                return
            }
            
            var result: Result<Data, Error>?
            if let data = data {
                result = .success(data)
            } else if let error = error {
                result = .failure(error)
            }
            
            DispatchQueue.main.async {
                if retry == 0 {
                    self.handleResponse(result: result, completion: completion, downloadTokens: downloadTokens)
                }
            }
        }.resume()
    }
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> Void, downloadTokens: Bool) {
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(T.self, from: data) else {
                completion(.failure(AppError.errorDecoding))
                return
            }
            
            if downloadTokens {
                saveTokensInKeyChain(tokenInfo: response as! TokenInfo)
            }
            
            completion(.success(response))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func createRequest(route: Route, method: HTTPMethod, parameters: [String: Any]? = nil) -> URLRequest? {
        let urlString = Route.baseURL + route.description
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = bodyData
        }
        
        return urlRequest
    }
    
    func refreshAccessToken(refreshToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let urlString = URL(string: Route.baseURL + "/refresh-token") else {
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
                keychainHelper.delete(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                keychainHelper.delete(service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
                completion(.failure(NSError(domain: "Refresh token expired, redirect to login", code: 401, userInfo: nil)))
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let newAccessToken = json["accessToken"] as? String {
                completion(.success(newAccessToken))
            } else {
                completion(.failure(NSError(domain: "Failed to refresh token", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
    }
    
    func createNewUser(user: User, completion: @escaping (Result<UserCreationResponse, Error>) -> Void) {
        let params = ["email": user.email, "password": user.password, "profileImageData": user.profileImageData]
        request(route: .createNewUser, method: .post, parameters: params, completion: completion, downloadTokens: false, withBearerToken: false)
    }
    
    func authenticateUser(userInfo: UserInfo, completion: @escaping (Result<TokenInfo, Error>) -> Void) {
        let params = ["email": userInfo.email, "password": userInfo.password]
        request(route: .authenticateUser, method: .post, parameters: params, completion: completion, downloadTokens: true, withBearerToken: false)
    }
    
    func getUserDetails(completion: @escaping (Result<UserProfileInfo, Error>) -> Void) {
        request(route: .getUserDetails, method: .get, completion: completion, downloadTokens: false, withBearerToken: true)
    }
    
    func saveNewProfilePic(profilePicString: String, completion: @escaping (Result<UserCreationResponse, Error>) -> Void) {
        let params = ["profile": profilePicString]
        request(route: .updateUserProfilePic, method: .put, parameters: params, completion: completion, downloadTokens: false, withBearerToken: true)
    }
    
    func getAllTransactions(completion: @escaping (Result<TransactionList, Error>) -> Void) {
        request(route: .getAllTransations, method: .get, completion: completion, downloadTokens: false, withBearerToken: true)
    }
    
    func addTransaction(description: String, amount: Int, transactionType: TransactionType, completion: @escaping (Result<Transaction, Error>) -> Void) {
        let params = ["type": transactionType.rawValue, "description": description, "amount": amount] as [String: Any]
        request(route: .createNewTransaction, method: .post, parameters: params, completion: completion, downloadTokens: false, withBearerToken: true)
    }
    
    func removeTransaction(id: Int, completion: @escaping (Result<Transaction, Error>) -> Void) {
        let route = Route.deleteTransaction(id: id)
        request(route: route, method: .delete, completion: completion, downloadTokens: false, withBearerToken: true)
    }
    
    func logOut(completion: @escaping (Result<UserProfileInfo, Error>) -> Void) {
        request(route: .logout, method: .post, completion: completion, downloadTokens: false, withBearerToken: true)
    }
    
    private func saveTokensInKeyChain(tokenInfo: TokenInfo) {
        keychainHelper.save(tokenInfo.accessToken, service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
        keychainHelper.save(tokenInfo.refreshToken, service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
    }
    
}

