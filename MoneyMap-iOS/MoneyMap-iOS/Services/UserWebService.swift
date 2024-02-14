//
//  UserWebService.swift
//  MoneyMap-iOS
//
//  Created by Venugopal Reddy M on 10/02/24.
//

import Foundation

final class UserWebService {
    
    private static let baseURL = "http://localhost:8082"
    
    static func createNewUser(_ userToCreate: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        
        guard let urlString = URL(string: baseURL + "/createUser") else {
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
        }
        catch{
            completion(.failure(NSError(domain: "Encoding Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode user data"])))
        }
        
    }

}

