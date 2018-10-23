//
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import XCTest
import Foundation

@testable import WHIR

class OpenLibraryBookTests: XCTestCase {

    // MARK: - Constants

    let defaultDate = "2017-06-24T04:15:17.639055"

    // MARK: - Tests

    func testShouldExtractDateWithCustomFormatter() {
        let actualValue = OpenLibraryBookDetails.CustomDateFormatter.date(from: defaultDate)

        XCTAssertNotNil(actualValue)
    }

    func testShouldInstantiateFromJSON() {
        guard let payload = payload(for: "open_library_book") else {
            XCTFail("Failed to retrieve payload")
            return
        }

        guard let actualValue = try? JSONDecoder().decode(OpenLibraryBook.self, from: payload) else {
             XCTFail()
            return
        }

        XCTAssertNotNil(actualValue)

        // General
        XCTAssertEqual(actualValue.infoURL, "https://openlibrary.org/books/OL26331930M/Harry_Potter_and_the_sorcerer's_stone")
        XCTAssertEqual(actualValue.bibKey, "ISBN:9780439708180")
        XCTAssertEqual(actualValue.previewURL, "https://archive.org/details/harrypottersorce00jkro_0")
        XCTAssertEqual(actualValue.thumbnailURL, "https://covers.openlibrary.org/b/id/-1-S.jpg")
        XCTAssertEqual(actualValue.preview, "borrow")

        // Details
        XCTAssertEqual(actualValue.details.covers, [-1])
        XCTAssertEqual(actualValue.details.latestRevision, 2)
        XCTAssertEqual(actualValue.details.ocaid, "harrypottersorce00jkro_0")
        XCTAssertEqual(actualValue.details.contributions, ["GrandPre , Mary"])
        XCTAssertEqual(actualValue.details.sourceRecords, ["ia:harrypottersorce00jkro_0"])
        XCTAssertEqual(actualValue.details.title, "Harry Potter and the sorcerer's stone")
        XCTAssertEqual(actualValue.details.workTitles, ["Harry Potter and the philosopher's stone"])
        XCTAssertEqual(actualValue.details.languages, [["key": "/languages/eng"]])
        XCTAssertEqual(actualValue.details.subjects, ["Magic", "Juvenile fiction", "Fiction", "Fantasy", "Wizards", "Witches", "Schools", "England", "Hogwarts School of Witchcraft and Wizardry (Imaginary organization)"])
        XCTAssertEqual(actualValue.details.publishCountry, "nyu")
        XCTAssertEqual(actualValue.details.byStatement, "by J.K. Rowling ; illustrations by Mary GrandPre .")
        XCTAssertEqual(actualValue.details.oclcNumbers, ["794451314"])
        XCTAssertEqual(actualValue.details.type, ["key": "/type/edition"])
        XCTAssertEqual(actualValue.details.revision, 2)
        XCTAssertEqual(actualValue.details.publishers, ["Scholastic"])
        XCTAssertEqual(actualValue.details.desc, "Rescued from the outrageous neglect of his aunt and uncle, a young boy with a great destiny proves his worth while attending Hogwarts School for Witchcraft and Wizardry.")
        XCTAssertEqual(actualValue.details.fullTitle, "Harry Potter and the sorcerer's stone")

        let lastModifiedDate = OpenLibraryBookDetails.CustomDateFormatter.date(from: "2018-08-08T13:19:54.218373")
        XCTAssertEqual(actualValue.details.lastModified, lastModifiedDate)

        XCTAssertEqual(actualValue.details.key, "/books/OL26331930M")
        XCTAssertEqual(actualValue.details.authors, [["name": "J. K. Rowling", "key": "/authors/OL23919A"]])
        XCTAssertEqual(actualValue.details.publishPlaces, ["New York"])
        XCTAssertEqual(actualValue.details.pagination, "309 pages :")

        let createdDate = OpenLibraryBookDetails.CustomDateFormatter.date(from: "2017-06-24T04:15:17.639055")
        XCTAssertEqual(actualValue.details.created, createdDate)

        XCTAssertEqual(actualValue.details.deweyDecimalClass, ["[Fic]"])
        XCTAssertEqual(actualValue.details.notes, "Sequel: Harry Potter and the Chamber of Secrets.\n\n\"This edition is only available for distribution through the school market\"--Page 4 of cover.")
        XCTAssertEqual(actualValue.details.numberOfPages, 309)
        XCTAssertEqual(actualValue.details.isbn13, ["9780439708180", "9780590353403"])
        XCTAssertEqual(actualValue.details.subjectPlaces, ["England"])
        XCTAssertEqual(actualValue.details.isbn10, ["0439708184", "0590353403"])
        XCTAssertEqual(actualValue.details.publishDate, "1997")
        XCTAssertEqual(actualValue.details.works, [["key": "/works/OL17731597W"]])
    }
}
