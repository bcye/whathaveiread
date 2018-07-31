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
extension Error {
    
    //displays alert from given controller with option to crash or not
    func alert(with controller: UIViewController, error: ErrorCases) {
        let alertController = UIAlertController(title: "Oops", message: error.description, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}

enum ErrorCases: CustomStringConvertible {
    case fetchFailed
    case loadingPersistentStoresFailed
    case saveFailed
    //frc = fetchedResultsController
    case frcFetchFailed
    case falseInput
    case other
    
    var description: String {
        switch self {
        case .fetchFailed, .frcFetchFailed: return "Error while fetching data"
        case .loadingPersistentStoresFailed: return "Error while loading necessary objects for data handling"
        case .saveFailed: return "Error while saving the transaction"
        case .falseInput: return "Given input is not valid"
        case .other: return "An unknown error happened"
        }
    }
}
