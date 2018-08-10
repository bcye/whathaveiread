//
//  ISBNSearchManager.swift
//  WHIR
//
//  Created by Bruce Röttgers on 10.08.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation
import UIKit

class ISBNSearcher {
    
    let errorViewController: UIViewController
    
    // abook that will be returned from the api
    struct Book: Decodable {
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
    
    // get api-key from keys.plist file
    private func getApiKey() -> String {
        let path = Bundle.main.path(forResource: "keys", ofType: "plist")!
        let keys = NSDictionary(contentsOfFile: path)!
        let key = keys["google_books_api_key"]! as! String
        return key
    }
    
    private func parseJSON(_ data: Data) throws -> Book {
        let decoder = JSONDecoder()
        let result = try decoder.decode(Book.self, from: data)
        return result
    }
    
    func searchFor(isbn: String, completion: @escaping (Book?) -> Void) {
        // create url object used for the get request
        let key = getApiKey()
        let requestURL = URL(string: "https://www.googleapis.com/books/v1/volumes?maxResults=1&q=isbn:\(isbn)&key=\(key)")
        // create the request task
        
        var request = URLRequest(url: requestURL!)
        request.addValue("dirkhulverscheidt.WHIR", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        let task = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // check for errors
            if let error = error {
                print(error)
                completion(nil)
                error.alert(with: self.errorViewController, error: .dataTaskFailed)
            }
            
            if let data = data {
                do {
                    let book = try self.parseJSON(data)
                    completion(book)
                } catch {
                    print(error)
                    print(data.description)
                    print(data.stringDescription)
                    error.alert(with: self.errorViewController, error: .parseFailed)
                    completion(nil)
                }
            }
        }
        
        // run the task
        task.resume()
    }
    
    init(alertErrorWith errorViewController: UIViewController) {
        self.errorViewController = errorViewController
    }
}

extension Data {
    public var stringDescription: String {
        return String(data: self, encoding: .utf8)!
    }
}
