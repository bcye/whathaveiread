//
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import XCTest

extension XCTestCase {

    // MARK: - Functions

    func payload(for jsonFile: String, subfolder: String = "") -> Data? {
        let bundle = Bundle(for: type(of: self)).url(forResource: "Payloads", withExtension: "bundle")!
        let urlBundle = Bundle(url: bundle)!

        if let data = try? Data(contentsOf: urlBundle.url(forResource: subfolder + jsonFile, withExtension: "json")!) {
            return data
        }

        return nil
    }
}
