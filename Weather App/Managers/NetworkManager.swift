//
//  NetworkManager.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func loadForecastWithCoord(lat: Double, lon: Double, completion: @escaping (Result) -> Void)
    func loadForecastWithCity(city: String, completion: @escaping (Result) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    private let baseaseURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let apiKey = "1f7f0d7b3906c31e1158ca98f1fea4c2"
    
    private func absoluteURLCoord(lat: Double, lon: Double) -> URL? {
        let queryURL = URL(string: baseaseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil }
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "lat", value: String(lat)),
                                    URLQueryItem(name: "lon", value: String(lon)),
                                    URLQueryItem(name: "units", value: "metric")]
        return urlComponents.url
    }
    
    private func absoluteURLCity(city: String) -> URL? {
        let queryURL = URL(string: baseaseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil }
        //let city = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "units", value: "metric")]
        return urlComponents.url
    }

    func loadForecastWithCoord(lat: Double, lon: Double, completion: @escaping (Result) -> Void) {

        if let url = absoluteURLCoord(lat: lat, lon: lon) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    let decoder = JSONDecoder()

                    guard let result = try? decoder.decode(Result.self, from: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
            urlSession.resume()
        }
    }
    
    func loadForecastWithCity(city: String, completion: @escaping (Result) -> Void) {

        if let url = absoluteURLCity(city: city) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    let decoder = JSONDecoder()

                    guard let result = try? decoder.decode(Result.self, from: data) else {
                        return
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
