//
//  ViewController.swift
//  Add
//
//  Created by Чистяков Василий Александрович on 07.08.2021.
//

import UIKit

enum KeysAddress: String {
    case city
    case street
    case home
    case build
    case room
}

class ViewController: UIViewController {
    
    var base: Base!
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var StreetField: UITextField!
    @IBOutlet weak var homeField: UITextField!
    @IBOutlet weak var buildField: UITextField!
    @IBOutlet weak var roomField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        base = Base()
        
        cityField.text = defaults.string(forKey:KeysAddress.city.rawValue)
        StreetField.text = defaults.string(forKey: KeysAddress.street.rawValue)
        homeField.text = defaults.string(forKey: KeysAddress.home.rawValue)
        buildField.text = defaults.string(forKey: KeysAddress.build.rawValue)
        roomField.text = defaults.string(forKey: KeysAddress.room.rawValue)
    }
    @IBAction func tapAction(_ sender: Any) {
        cityField.resignFirstResponder()
        StreetField.resignFirstResponder()
        homeField.resignFirstResponder()
        buildField.resignFirstResponder()
        roomField.resignFirstResponder()
    }
    
    @IBAction func saveAddress(_ sender: Any) {
        let city = cityField.text!
        let street = StreetField.text!
        let home = homeField.text!
        let build = buildField.text!
        let room = roomField.text!
        
        if !city.isEmpty && !street.isEmpty && !home.isEmpty {
            
            base.saveAction(city: city, street: street, home: home, build: build, room: room)
            navigationController?.popViewController(animated: true)
        }
    }
}

