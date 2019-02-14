//
//  GBooksService.swift
//  WHIR
//
//  Created by Bruce Roettgers on 30.12.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation
import Alamofire

class GBooksService {
    
    
    
    // get api-key from keys.plist file
    //    private func getApiKey() -> String {
    //        let path = Bundle.main.path(forResource: "keys", ofType: "plist")!
    //        let keys = NSDictionary(contentsOfFile: path)!
    //        let key = keys["google_books_api_key"]! as! String
    //        return key
    //    }
    
    private func parseJSON(_ data: Data) throws -> GBook {
        let decoder = JSONDecoder()
        let result = try decoder.decode(GBook.self, from: data)
        return result
    }
    
    static func search(isbn: String, completion: @escaping (GBook?, ErrorCases?) -> Void) {
        // create url object used for the get request
        //        let key = getApiKey()
        guard let key = ApiKeyService().googleKey, let requestURL = URL(string: "https://www.googleapis.com/books/v1/volumes?maxResults=1&q=isbn:\(isbn)&key=\(key)") else {
            completion(nil, nil)
            return
        }
        // create the request task
        
        var request = URLRequest(url: requestURL)
        request.addValue("dirkhulverscheidt.WHIR", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check for errors
            if let error = error {
                print(error)
                completion(nil, ErrorCases.other)
            }
            
//            if let data = data {
//                do {
//                    let book = try self.parseJSON(data)
//                    completion(book)
//                } catch {
//                    print(error)
//                    print(data.description)
//                    print(data.stringDescription)
//                    completion(nil)
//                }
//            }
            
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let book = try decoder.decode(GBook.self, from: data)
                    completion(book, nil)
                } catch {
                    completion(nil, .other)
                    return
                }
                
            }
        }.resume()
    }
    
    static func fetchImage(forBookTitle title: String, completion: @escaping (UIImage?, GBooksError?) -> Void) {
        guard let key = ApiKeyService().googleKey else {
            completion(nil, GBooksError.apiKeyDoesNotExist)
            return
        }

        Alamofire.request("https://www.googleapis.com/books/v1/volumes?maxResults=1&q=\(title)&key=\(key)", headers: ["X-Ios-Bundle-Identifier": "dirkhulverscheidt.WHIR"]).validate().responseJSON { (response) in
            
            guard let json = response.result.value as? NSDictionary,
                let array = json["items"] as? NSArray,
                let firstItem = array[0] as? NSDictionary,
                let info = firstItem["volumeInfo"] as? NSDictionary,
                let pictureDict = info["imageLinks"] as? NSDictionary,
                let thumbnailURL = pictureDict["thumbnail"] as? String else {
                    completion(nil, GBooksError.jsonInvalid)
                    return
                }
            
            
            
            Alamofire.request(thumbnailURL).responseData(completionHandler: { (response) in
                if let data = response.data {
                    let image = UIImage(data: data)
                        completion(image, nil)
                    }
                })

        }
        
        // request.addValue("dirkhulverscheidt.WHIR", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
    }
}

extension Data {
    public var stringDescription: String {
        return String(data: self, encoding: .utf8) ?? "failed"
    }
}

enum GBooksError: Error {
    case apiKeyDoesNotExist
    case jsonInvalid
    
    var description: String {
        switch self {
        case .apiKeyDoesNotExist: return "There has been an error loading the API key"
        case .jsonInvalid: return "The downloaded image data is invalid"
        }
    }
}
