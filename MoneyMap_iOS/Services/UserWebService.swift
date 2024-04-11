//
//  UserWebService.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 10/02/24.
//
import Foundation

final class UserWebService {

    private static let baseURL = "http://localhost:8082"
    
    private static let keychainHelper = KeychainHelper.standard
    

    static func createNewUser(_ userToCreate: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let urlString = URL(string: baseURL + "/register") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        do {
            let jsonData = try JSONEncoder().encode(userToCreate)
            var request = URLRequest(url: urlString)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data, !data.isEmpty else {
                    completion(.failure(NSError(domain: "No data or empty data received", code: -1, userInfo: nil)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "Invalid response", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)))
                    return
                }

                completion(.success(true))
            }.resume()
        } catch {
            completion(.failure(NSError(domain: "Encoding Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode user data"])))
        }
    }

    
    
    static func getUserDetails(completion: @escaping (Result<UserProfileInfo, Error>) -> Void) {
        guard let urlString = URL(string: baseURL + "/user/get") else {
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
                            getUserDetails(completion: completion) // Retry the request
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
                                 let json = try? JSONSerialization.jsonObject(with: data, options: []),
                                 let dictionary = json as? [String: Any],
                                 let email = dictionary["email"] as? String,
                                 let profile = dictionary["profile"] as? String
                                else {
                               completion(.failure(NSError(domain: "Failed to parse JSON", code: -1, userInfo: nil)))
                               return
                           }
                let userProfileInfo = UserProfileInfo(email: email, profile: profile)
                completion(.success(userProfileInfo))
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
    
    
    static func logoutUser(completion: @escaping (Result<Bool, Error>) -> Void){
        guard let urlString = URL(string: baseURL + "/logout") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        guard let accessToken = keychainHelper.readAsString(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
        else {
            
            completion(.failure(NSError(domain: "No values in Keychain, redirect to login", code: -1, userInfo: nil)))
            return
            
        }
        print("urlString :  \(urlString)")
        print("Access Token : \(accessToken)")
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
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
            print("returned 401")
            completion(.failure(NSError(domain: "Failed to encode new access token", code: -1, userInfo: nil)))
                       
            
            } else if (200...299).contains(httpResponse.statusCode) {
                
                //print("Deleting tokens from KeyChain")
                //keychainHelper.delete(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount)
                //keychainHelper.delete(service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
                
                completion(.success(true))
            } else {
                // Other errors
                completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
            }
            
           
            
        }.resume()
        
        
        
    }
    
    static func saveNewProfilePic(profilePicString:String ,completion: @escaping (Result<Bool, Error>) -> Void)
    {
        
        guard let urlString = URL(string: baseURL + "/user/update-profileImageData") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        guard let accessToken = keychainHelper.readAsString(service: KeyChainConstants.accessTokenService, account: KeyChainConstants.tokenAccount),
              let refreshToken = keychainHelper.readAsString(service: KeyChainConstants.refreshTokenService, account: KeyChainConstants.tokenAccount)
        else {
            
            completion(.failure(NSError(domain: "No values in Keychain, redirect to login", code: -1, userInfo: nil)))
            return
            
        }
        print("URLString : \(urlString)")
        var request = URLRequest(url: urlString)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let requestBody: [String: String] = ["profile": profilePicString]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) 
        else {
            completion(.failure(NSError(domain: "JSON Serialization Error", code: -1, userInfo: nil)))
                    return
            }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        print("Line 241")
        print("JSON \(jsonData)")
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
                            saveNewProfilePic(profilePicString: profilePicString, completion: completion) // Retry the request
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
                print("Line 276")
                completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
        
        
    }
    
    
    
}


