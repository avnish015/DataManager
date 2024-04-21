//
//  KeyChainManager.swift
//  Interview_preparation
//
//  Created by Avnish Kumar on 22/04/24.
//

import Foundation
import CryptoKit

struct KeyChainManager: DataManager {
    
    private let serviceName = "com.app.keychaain"
    
    func read<T>(type: T.Type, key: String) -> T? where T : Decodable {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                  return nil
        }
        return decodedData
    }
    
    func write<T>(data: T, key: String) -> Bool where T : Encodable {
        guard let data = try? JSONEncoder().encode(data) else {
            return false
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            return false
        }
        return true
    }
    
    func dataExists(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: kCFBooleanTrue!
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        return status == errSecSuccess
    }
    
    func remove(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        let _ = SecItemDelete(query as CFDictionary)
    }
    
    
    
}
