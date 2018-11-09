//
//  ISBNTests.swift
//  WHIRTests
//
//  Created by Michael Hulet on 11/9/18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import XCTest
@testable import WHIR

class ISBNTests: XCTestCase {

    func testValidatesISBN10() {
        XCTAssertTrue(BarcodeScannerViewController.isValid(isbn: "9780312204280"))
    }

    func testValidatesISBN13() {
        XCTAssertTrue(BarcodeScannerViewController.isValid(isbn: "9783161484100"))
    }

    func testInvalidatesUnrelatedEAN13Code() {
        XCTAssertFalse(BarcodeScannerViewController.isValid(isbn: "1234567891231"))
    }
}
