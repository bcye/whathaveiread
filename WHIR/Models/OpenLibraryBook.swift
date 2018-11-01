//
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation

struct OpenLibraryBook: Decodable {

    // MARK: - Constants

    enum CodingKeys: String, CodingKey {
        case infoURL = "info_url"
        case bibKey = "bib_key"
        case previewURL = "preview_url"
        case thumbnailURL = "thumbnail_url"
        case details
        case preview
    }

    // MARK: - Properties

    let infoURL: String?
    let bibKey: String?
    let previewURL: String?
    let thumbnailURL: String?
    let details: OpenLibraryBookDetails
    let preview: String?
}

struct OpenLibraryBookDetails {

    // MARK: - Constants

    static let CustomDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        return dateFormatter
    }()

    // MARK: - Properties

    let covers: [Int]?
    let latestRevision: UInt?
    let ocaid: String?
    let contributions: [String]?
    let sourceRecords: [String]?
    let title: String
    let workTitles: [String]?
    let languages: [[String: String]]?
    let subjects: [String]?
    let publishCountry: String?
    let byStatement: String?
    let oclcNumbers: [String]?
    let type: [String: String]?
    let revision: UInt?
    let publishers: [String]?
    let desc: String?
    let fullTitle: String?
    let lastModified: Date?
    let key: String?
    let authors: [[String: String]]?
    let publishPlaces: [String]?
    let pagination: String?
    let created: Date?
    let deweyDecimalClass: [String]?
    let notes: String?
    let numberOfPages: UInt?
    let isbn13: [String]?
    let subjectPlaces: [String]?
    let isbn10: [String]?
    let publishDate: String?
    let works: [[String: String]]?
}

extension OpenLibraryBookDetails: Decodable {

    // MARK: - Constants

    enum CodingKeys: String, CodingKey {
        case covers
        case latestRevision = "latest_revision"
        case ocaid
        case contributions
        case sourceRecords = "source_records"
        case title
        case workTitles = "work_titles"
        case languages
        case subjects
        case publishCountry = "publish_country"
        case byStatement = "by_statement"
        case oclcNumbers = "oclc_numbers"
        case type
        case revision
        case publishers
        case desc = "description"
        case fullTitle = "full_title"
        case lastModified = "last_modified"
        case key
        case authors
        case publishPlaces = "publish_places"
        case pagination
        case created
        case deweyDecimalClass = "dewey_decimal_class"
        case notes
        case numberOfPages = "number_of_pages"
        case isbn13 = "isbn_13"
        case subjectPlaces = "subject_places"
        case isbn10 = "isbn_10"
        case publishDate = "publish_date"
        case works
    }

    // MARK: - Initialization

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        covers = try container.decodeIfPresent([Int].self, forKey: .covers)
        latestRevision = try container.decodeIfPresent(UInt.self, forKey: .latestRevision)
        ocaid = try container.decodeIfPresent(String.self, forKey: .ocaid)
        contributions = try container.decodeIfPresent([String].self, forKey: .contributions)
        sourceRecords = try container.decodeIfPresent([String].self, forKey: .sourceRecords)
        title = try container.decode(String.self, forKey: .title)
        workTitles = try container.decodeIfPresent([String].self, forKey: .workTitles)
        languages = try container.decodeIfPresent([[String: String]].self, forKey: .languages)
        subjects = try container.decodeIfPresent([String].self, forKey: .subjects)
        publishCountry = try container.decodeIfPresent(String.self, forKey: .publishCountry)
        byStatement = try container.decodeIfPresent(String.self, forKey: .byStatement)
        oclcNumbers = try container.decodeIfPresent([String].self, forKey: .oclcNumbers)
        type = try container.decodeIfPresent([String: String].self, forKey: .type)
        revision = try container.decodeIfPresent(UInt.self, forKey: .revision)
        publishers = try container.decodeIfPresent([String].self, forKey: .publishers)

        desc = OpenLibraryBookDetails.value(from: container, key: .desc)

        fullTitle = try container.decodeIfPresent(String.self, forKey: .fullTitle)

        if
            let value = OpenLibraryBookDetails.value(from: container, key: .lastModified),
            let date = OpenLibraryBookDetails.CustomDateFormatter.date(from: value) {
            lastModified = date
        } else {
            lastModified = Date()
        }

        key = try container.decodeIfPresent(String.self, forKey: .key)
        authors = try container.decodeIfPresent([[String: String]].self, forKey: .authors)
        publishPlaces = try container.decodeIfPresent([String].self, forKey: .publishPlaces)
        pagination = try container.decodeIfPresent(String.self, forKey: .pagination)

        if
            let value = OpenLibraryBookDetails.value(from: container, key: .created),
            let date = OpenLibraryBookDetails.CustomDateFormatter.date(from: value) {
            created = date
        } else {
            created = Date()
        }

        deweyDecimalClass = try container.decodeIfPresent([String].self, forKey: .deweyDecimalClass)

        notes = OpenLibraryBookDetails.value(from: container, key: .notes)

        numberOfPages = try container.decodeIfPresent(UInt.self, forKey: .numberOfPages)
        isbn13 = try container.decodeIfPresent([String].self, forKey: .isbn13)
        subjectPlaces = try container.decodeIfPresent([String].self, forKey: .subjectPlaces)
        isbn10 = try container.decodeIfPresent([String].self, forKey: .isbn10)
        publishDate = try container.decodeIfPresent(String.self, forKey: .publishDate)
        works = try container.decodeIfPresent([[String: String]].self, forKey: .works)
    }

    private static func value(from container: KeyedDecodingContainer<OpenLibraryBookDetails.CodingKeys>, key: OpenLibraryBookDetails.CodingKeys) -> String? {
        guard let rootNode = try? container.decodeIfPresent([String: String].self, forKey: key) else {
            return nil
        }

        return rootNode?["value"]
    }
}
