//
//  Service.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 29/08/2023.
//

import Foundation

class Service {
    static let shared = Service()
    private let baseURL = "https://rickandmortyapi.com/api/character/"
    
    private init() {}
    
    
    func getAllCharacterData(ids: [Int], completed: @escaping (Result<[Character], Error>) -> Void) {
        let idsString = ids.map { String($0) }.joined(separator: ",")
        let endpoint = baseURL + idsString
        guard let url = URL(string: endpoint) else {
            completed(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completed(.failure(error))
                return
            }
            
            guard let data = data else {
                completed(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let characterResponse = try decoder.decode([Character].self, from: data)
                completed(.success(characterResponse))
            } catch {
                completed(.failure(error))
            }
        }
        task.resume()
    }
    
    func getLocationCharacterData(url: String, completed: @escaping (Result<LocationData, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completed(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completed(.failure(error))
                return
            }
            
            guard let data = data else {
                completed(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let locationResponse = try decoder.decode(LocationData.self, from: data)
                completed(.success(locationResponse))
            } catch {
                completed(.failure(error))
            }
        }
        task.resume()
    }
}
