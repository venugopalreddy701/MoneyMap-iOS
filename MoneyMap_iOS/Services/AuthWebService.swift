//
//  AuthWebService.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 26/02/24.
//

import Foundation

final class AuthWebService{
    
    private let baseURL = "http://localhost:8082"
    
    func authenticateUser(email:String , password:String,completion: @escaping (Result<Bool, Error>) -> Void)
    {
        guard let urlString = URL(string: baseURL + "/login") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        do{
            let requestBody: [String: String] = ["email": email, "password": password]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
                        completion(.failure(NSError(domain: "JSON Serialization Error", code: -1, userInfo: nil)))
                        return
            }
            print("JSON Data that will be sent: \(jsonData)")
            
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
                    print("http code: \(httpResponse.statusCode)")
                } else {
                            completion(.failure(NSError(domain: "Invalid response", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)))
                            return
                        }

                        completion(.success(true))
                        print("Success")
                
                
                    }.resume()

            
        }
        catch{
            completion(.failure(NSError(domain: "Encoding Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode user data"])))
        }
        
        
        
        
        
    }
    
}
