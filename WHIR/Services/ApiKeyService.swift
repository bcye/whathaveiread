//
//  File.swift
//  WHIR
//
//  Created by Bruce Roettgers on 2018-10-31.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation

class ApiKeyService {
    let path = Bundle.main.path(forResource: "Resources/keys", ofType: "plist")
    var key: String {
        let dict = NSDictionary(contentsOfFile: path!)
        return dict?["API_KEY"] as! String
    }
}
