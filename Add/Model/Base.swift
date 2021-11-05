//
//  Base.swift
//  Add
//
//  Created by Чистяков Василий Александрович on 07.08.2021.
//

import Foundation

class Base {
    
    let defaults = UserDefaults.standard
    
    struct UserAddress: Codable {
        var city: String
        var street: String
        var home: String
        var build: String?
        var room: String?
        var name: String {
            return "\(city) \(street) \(home) \(build ?? "") \(room ?? "")"
        }
    }
    
    var address: [UserAddress] {
        get {
            if let data = defaults.value(forKey: "address") as? Data {
                return try! PropertyListDecoder().decode([UserAddress].self, from: data)
            } else {
                return [UserAddress]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.setValue(data, forKey: "address")
            }
        }
    }
    
    func saveAction(city: String, street: String, home: String, build: String, room: String){
        let addres = UserAddress(city: city, street: street, home: home, build: build, room: room)
        address.insert(addres, at: 0)
    }
}


