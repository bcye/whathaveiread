//
//  AlertableError.swift
//  MoneyTracker
//
//  Created by Bruce Röttgers on 25.01.18.
//  Copyright © 2018 bcye. All rights reserved.
//

import Foundation
import UIKit

//extending error to make it alertible
extension ErrorCases {

    //displays alert from given controller with option to crash or not
    func alert(with controller: UIViewController) {
        let alertController = UIAlertController(title: "Oops", message: localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}

enum ErrorCases: Error, CustomStringConvertible {

    // MARK: - Constants

    case fetchFailed
    case loadingPersistentStoresFailed
    case saveFailed
    //frc = fetchedResultsController
    case frcFetchFailed
    case falseInput
    case dataTaskFailed
    case other
    case parseFailed

    // MARK: - Properties

    var description: String {
        return localizedDescription
    }

    var localizedDescription: String {
        switch self {
        case .fetchFailed, .frcFetchFailed: return "Error while fetching data"
        case .loadingPersistentStoresFailed: return "Error while loading necessary objects for data handling"
        case .saveFailed: return "Error while saving the transaction"
        case .falseInput: return "Given input is not valid"
        case .dataTaskFailed: return "We were unable to retrieve information on the book from OpenLibrary"
        case .parseFailed: return "We were unable to parse the response from Google Books"
        case .other: return "An unknown error happened"
        }
    }
}
