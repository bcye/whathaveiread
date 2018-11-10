//
//  APIKeyTests.swift
//  WHIRTests
//
//  Created by Bruce Roettgers on 2018-11-10.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import XCTest
@testable import WHIR

class APIKeyTests: XCTestCase {
    
    let service = ApiKeyService()

    func testGetPath() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        guard let path = service.path else {
            XCTFail("NO PATH PRESENT")
            return
        }
    }
    
    func testGetKey() {
        guard let key = service.key else {
            XCTFail("NO KEY PRESENT")
            return
        }
    }

}
