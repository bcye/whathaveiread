//
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation

final class OpenLibraryService {

    /// If the supplied ISBN exists on **OpenLibrary**, returns an `OpenLibraryBook`, otherwise returns `nil`.
    static func search(ISBN: String, completionHandler: @escaping (OpenLibraryBook?, ErrorCases?) -> Void) {
        guard let url = URL(string: "https://openlibrary.org/api/books?bibkeys=isbn:\(ISBN)&format=json&jscmd=details") else {
            completionHandler(nil, nil)
            return
        }

        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                completionHandler(nil, ErrorCases.other)
                return
            }

            if let data = data {
                do {
                    let bundle = try JSONDecoder().decode(([String: OpenLibraryBook]).self, from: data)

                    guard let firstBook = bundle.first?.value else {
                        completionHandler(nil, ErrorCases.fetchFailed)
                        return
                    }

                    completionHandler(firstBook, nil)
                } catch {
                    print(error)
                    print(data.description)
                    print(data.stringDescription)
                    completionHandler(nil, ErrorCases.parseFailed)
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
