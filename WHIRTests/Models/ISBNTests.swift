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
        XCTAssertTrue(BarcodeScannerViewController.isValid(isbn: "9781576833346"))
    }

    func testValidatesISBN13() {
        XCTAssertTrue(BarcodeScannerViewController.isValid(isbn: "9783161484100"))
        XCTAssertTrue(BarcodeScannerViewController.isValid(isbn: "9781942878537"))
    }

    func testInvalidatesUnrelatedEAN13Code() {
        XCTAssertFalse(BarcodeScannerViewController.isValid(isbn: "1234567891234"))
        XCTAssertFalse(BarcodeScannerViewController.isValid(isbn: "5901234123457"))
    }

    func testInvalidatesUnrelatedData() {
        XCTAssertFalse(BarcodeScannerViewController.isValid(isbn: "123"))
        XCTAssertFalse(BarcodeScannerViewController.isValid(isbn: "Unrelated"))
        XCTAssertFalse(BarcodeScannerViewController.isValid(isbn: ""))
    }
}
