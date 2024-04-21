//
//  DataManager.swift
//  Interview_preparation
//
//  Created by Avnish Kumar on 22/04/24.
//

import Foundation

protocol DataManager {
    func read<T: Decodable>(type: T.Type, key: String) -> T?
    func write<T: Encodable>(data: T, key: String) -> Bool
    func dataExists(key: String) -> Bool
    func remove(key: String)
}
