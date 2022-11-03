//
//  NetworkManager.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func loadForecast(completion: @escaping (Result) -> Void)
}

class NetworkManager: NetworkManagerProtocol {

    func loadForecast(completion: @escaping (Result) -> Void) {
        
        let requestString = "https://api.openweathermap.org/data/2.5/forecast?lat=57&lon=-2.15&appid=1f7f0d7b3906c31e1158ca98f1fea4c2&units=metric"
        
        
        if let url = URL(string: requestString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    guard let result = try? decoder.decode(Result.self, from: data) else {
                        fatalError("Could not decode data")
                    }
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
            urlSession.resume()
        }
    }
    
}
