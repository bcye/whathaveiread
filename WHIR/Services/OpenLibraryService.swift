//
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation

final class ISBNDBService {

    /// If the supplied ISBN exists on **ISBNDB**, returns an `ISBNDBBook`, otherwise returns `nil`.
    static func search(isbn: String, completionHandler: @escaping (ISBNDBBook?, ErrorCases?) -> Void) {
        guard let url = URL(string: "https://api.isbndb.com/book/\(isbn)") else {
            completionHandler(nil, nil)
            return
        }
        let key = ApiKeyService().key

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "X-API-KEY")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                completionHandler(nil, ErrorCases.other)
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let book = try decoder.decode(ISBNDBBook.self, from: data)
                    completionHandler(book, nil)
                } catch {
                    completionHandler(nil, .other)
                    return
                }
                
            }
        }.resume()
    }
}

extension Data {

    public var stringDescription: String {
        return String(data: self, encoding: .utf8)!
    }
}
