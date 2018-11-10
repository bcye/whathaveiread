//
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation

struct ISBNDBBook: Decodable {
    let title: String
    let titleLong: String
    let isbn13: String
    let overview: String
}
