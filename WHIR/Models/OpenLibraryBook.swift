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

    let infoURL: String
    let bibKey: String
    let previewURL: String
    let thumbnailURL: String
    let details: OpenLibraryBookDetails
    let preview: String
}

struct OpenLibraryBookDetails {

    // MARK: - Constants

    static let CustomDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        return dateFormatter
    }()

    // MARK: - Properties

    let covers: [Int]
    let latestRevision: UInt
    let ocaid: String
    let contributions: [String]
    let sourceRecords: [String]
    let title: String
    let workTitles: [String]
    let languages: [[String: String]]
    let subjects: [String]
    let publishCountry: String
    let byStatement: String
    let oclcNumbers: [String]
    let type: [String: String]
    let revision: UInt
    let publishers: [String]
    let desc: String
    let fullTitle: String
    let lastModified: Date
    let key: String
    let authors: [[String: String]]
    let publishPlaces: [String]
    let pagination: String
    let created: Date
    let deweyDecimalClass: [String]
    let notes: String
    let numberOfPages: UInt
    let isbn13: [String]
    let subjectPlaces: [String]
    let isbn10: [String]
    let publishDate: String
    let works: [[String: String]]
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

        covers = try container.decode([Int].self, forKey: OpenLibraryBookDetails.CodingKeys.covers)
        latestRevision = try container.decode(UInt.self, forKey: OpenLibraryBookDetails.CodingKeys.latestRevision)
        ocaid = try container.decode(String.self, forKey: OpenLibraryBookDetails.CodingKeys.ocaid)
        contributions = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.contributions)
        sourceRecords = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.sourceRecords)
        title = try container.decode(String.self, forKey: OpenLibraryBookDetails.CodingKeys.title)
        workTitles = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.workTitles)
        languages = try container.decode([[String: String]].self, forKey: OpenLibraryBookDetails.CodingKeys.languages)
        subjects = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.subjects)
        publishCountry = try container.decode(String.self, forKey: OpenLibraryBookDetails.CodingKeys.publishCountry)
        byStatement = try container.decode(String.self, forKey: OpenLibraryBookDetails.CodingKeys.byStatement)
        oclcNumbers = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.oclcNumbers)
        type = try container.decode([String: String].self, forKey: OpenLibraryBookDetails.CodingKeys.type)
        revision = try container.decode(UInt.self, forKey: OpenLibraryBookDetails.CodingKeys.revision)
        publishers = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.publishers)

        if let value = OpenLibraryBookDetails.value(from: container, key: OpenLibraryBookDetails.CodingKeys.desc) {
            desc = value
        } else {
            desc = ""
        }

        fullTitle = try container.decode(String.self, forKey: OpenLibraryBookDetails.CodingKeys.fullTitle)

        if
            let value = OpenLibraryBookDetails.value(from: container, key: OpenLibraryBookDetails.CodingKeys.lastModified),
            let date = OpenLibraryBookDetails.CustomDateFormatter.date(from: value) {
            lastModified = date
        } else {
            lastModified = Date()
        }

        key = try container.decode(String.self, forKey: OpenLibraryBookDetails.CodingKeys.key)
        authors = try container.decode([[String: String]].self, forKey: OpenLibraryBookDetails.CodingKeys.authors)
        publishPlaces = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.publishPlaces)
        pagination = try container.decode(String.self, forKey: OpenLibraryBookDetails.CodingKeys.pagination)

        if
            let value = OpenLibraryBookDetails.value(from: container, key: OpenLibraryBookDetails.CodingKeys.created),
            let date = OpenLibraryBookDetails.CustomDateFormatter.date(from: value) {
            created = date
        } else {
            created = Date()
        }

        deweyDecimalClass = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.deweyDecimalClass)

        if let value = OpenLibraryBookDetails.value(from: container, key: OpenLibraryBookDetails.CodingKeys.notes) {
            notes = value
        } else {
            notes = ""
        }

        numberOfPages = try container.decode(UInt.self, forKey: OpenLibraryBookDetails.CodingKeys.numberOfPages)
        isbn13 = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.isbn13)
        subjectPlaces = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.subjectPlaces)
        isbn10 = try container.decode([String].self, forKey: OpenLibraryBookDetails.CodingKeys.isbn10)
        publishDate = try container.decode(String.self, forKey: OpenLibraryBookDetails.CodingKeys.publishDate)
        works = try container.decode([[String: String]].self, forKey: OpenLibraryBookDetails.CodingKeys.works)
    }

    private static func value(from container: KeyedDecodingContainer<OpenLibraryBookDetails.CodingKeys>, key: OpenLibraryBookDetails.CodingKeys) -> String? {
        guard let rootNode = try? container.decode([String: String].self, forKey: key), let value = rootNode["value"] else {
            return nil
        }

        return value
    }
}
