//
//  PlistManager.swift
//  Interview_preparation
//
//  Created by Avnish Kumar on 22/04/24.
//

import Foundation

struct PlistManager: DataManager {
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    private func getPlistURL() -> URL? {
        var documentDirecotry = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if #available(macOS 13.0, *) {
            documentDirecotry?.append(component: "\(name).plist")
        } else {
            // Fallback on earlier versions
        }
        guard let plistURL = documentDirecotry else  {
            return nil
        }
        return plistURL
    }
    
    private func getDictionary() -> NSMutableDictionary? {
        guard let plistURL = getPlistURL() else  {
            return nil
        }
        
        if !FileManager.default.fileExists(atPath: plistURL.relativePath) {
            let dictionary = NSMutableDictionary()
            try? dictionary.write(to: plistURL)
        }
        return NSMutableDictionary(contentsOf: plistURL)
    }
    
    func read<T>(type: T.Type, key: String) -> T? where T : Decodable {
        guard let dictionary = getDictionary() else {
            return nil
        }
        if let data = dictionary[key] as? Data, let decodedData = try? JSONDecoder().decode(T.self, from: data) {
            return decodedData
        }
        return nil
    }
    
    func write<T>(data: T, key: String) -> Bool where T : Encodable {
        guard let data = try? JSONEncoder().encode(data) else {
            return false
        }
        guard let dictionary = getDictionary() else {
            return false
        }
        guard let url = getPlistURL() else {
            return false
        }

        dictionary[key] = data
        
        return (try? dictionary.write(to: url)) != nil
    }
    
    func dataExists(key: String) -> Bool {
        guard let dictionary = getDictionary() else {
            return false
        }
        return dictionary[key] != nil
    }
    
    func remove(key: String) {
        guard let dictionary = getDictionary() else {
            return
        }
        
        guard let url = getPlistURL() else {
            return
        }
        dictionary.removeObject(forKey: key)
        try? dictionary.write(to: url)
    }
}

