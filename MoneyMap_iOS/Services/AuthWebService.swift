//
//  AuthWebService.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 26/02/24.
//

import Foundation

final class AuthWebService{
    
    private let baseURL = "http://localhost:8082"
    
    func authenticateUser(email:String , password:String,completion: @escaping (Result<(accessToken: String, refreshToken: String), Error>) -> Void)
    {
        guard let urlString = URL(string: baseURL + "/login") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        
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
            }
            else
            {
                completion(.failure(NSError(domain: "Invalid response", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)))
                return
            }
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let accessToken = json["accessToken"] as? String ,
               let refreshToken = json["refreshToken"] as? String {
                completion(.success((accessToken: accessToken, refreshToken: refreshToken)))
            } else {
                completion(.failure(NSError(domain: "Invalid response data", code: -1, userInfo: nil)))
            }
            
            
        }.resume()
        
    }
    
  
    
}

