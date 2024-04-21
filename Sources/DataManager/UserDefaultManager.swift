//
//  UserDefaultManager.swift
//  Interview_preparation
//
//  Created by Avnish Kumar on 22/04/24.
//

import Foundation

struct UserDefaultManager: DataManager {
    
    private let userDefault = UserDefaults.standard
    
    func read<T>(type: T.Type, key: String) -> T? where T : Decodable {
        guard let data = userDefault.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        if let decoderData = try? decoder.decode(T.self, from: data) {
            return decoderData
        } else {
            return nil
        }
    }
    
    func write<T>(data: T, key: String) -> Bool where T : Encodable {
        guard let data = try? JSONEncoder().encode(data) else {
            return false
        }
        userDefault.set(data, forKey: key)
        return true
    }
    
    func dataExists(key: String) -> Bool {
        userDefault.data(forKey: key) != nil
    }
    
    func remove(key: String) {
        userDefault.removeObject(forKey: key)
    }
}
