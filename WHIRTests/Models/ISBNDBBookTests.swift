//
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import XCTest
import Foundation

@testable import WHIR

class ISBNDBBookTests: XCTestCase {

    // MARK: - Tests

    func testShouldGetBook1984() {
        
        ISBNDBService.search(isbn: "9780451524935") { (book, error) in
            guard let book = book else {
                XCTFail("NO BOOK INSTANCE")
                return
            }
            
            XCTAssert(book.title == "1984")
            XCTAssert(book.titleLong == "1984")
            XCTAssert(book.isbn13 == "9780451524935")
            XCTAssert(book.overview == "<p class=null1>View our feature on George Orwellâs <i>1984</i>.</p><p>Written in 1948, <i>1984</i> was George Orwellâs chilling prophecy about the future. And while 1984 has come and gone, Orwellâs narrative is timelier than ever. <i>1984</i> presents a startling and haunting vision of the world, so powerful that it is completely convincing from start to finish. No one can deny the power of this novel, its hold on the imaginations of multiple generations of readers, or the resiliency of its admonitions-a legacy that seems only to grow with the passage of time.</p>                        <p>Examines different aspects of Orwell's anti-utopian classic, with a biographical sketch of the author and critical essays on this work.</p>")
        }
        
    }
}
