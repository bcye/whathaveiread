//
//  GBook.swift
//  WHIR
//
//  Created by Bruce Roettgers on 30.12.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation

struct GBook: Decodable {
    // title of the book
    let title: String
    // content summary of the book
    let description: String?
    
    /*
     * 3 layer nested containers
     * unkeyed because of array (see api docs)
     * after that decodes title and description if present (else nil)
     */
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootContainerKeys.self)
        var itemsContainer = try rootContainer.nestedUnkeyedContainer(forKey: .items)
        let itemContainer = try itemsContainer.nestedContainer(keyedBy: ItemKeys.self)
        let myContainer = try itemContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        self.title = try myContainer.decode(String.self, forKey: .title)
        self.description = try myContainer.decodeIfPresent(String.self, forKey: .description)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description
    }
    
    private enum RootContainerKeys: CodingKey {
        case items
    }
    
    private enum ItemKeys: CodingKey {
        case volumeInfo
    }
}
