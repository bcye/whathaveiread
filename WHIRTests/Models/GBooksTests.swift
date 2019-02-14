//
//  GBooksTests.swift
//  WHIRTests
//
//  Created by Bruce Roettgers on 13.02.19.
//  Copyright © 2019 Dirk Hulverscheidt. All rights reserved.
//

import XCTest
@testable import WHIR

class GBooksTests: XCTestCase {
    func testShouldFetchBookInformation() {
        GBooksService.search(isbn: "9781443452489") { (book, error) in
            if let error = error {
                XCTFail(error.description)
            }
            
            XCTAssert(book?.title == "Educated")
            XCTAssert(book?.description == "For readers of North of Normal and Wild, a stunning new memoir about family, loss and the struggle for a better future Tara Westover was seventeen when she first set foot in a classroom. Instead of traditional lessons, she grew up learning how to stew herbs into medicine, scavenging in the family scrap yard and helping her family prepare for the apocalypse. She had no birth certificate and no medical records and had never been enrolled in school. Westover’s mother proved a marvel at concocting folk remedies for many ailments. As Tara developed her own coping mechanisms, little by little, she started to realize that what her family was offering didn’t have to be her only education. Her first day of university was her first day in school—ever—and she would eventually win an esteemed fellowship from Cambridge and graduate with a PhD in intellectual history and political thought.")
        }
    }
}
