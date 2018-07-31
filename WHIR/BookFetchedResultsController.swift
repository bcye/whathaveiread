//
//  TransactionFetchedResultsController.swift
//  MoneyTracker
//
//  Created by Bruce Röttgers on 23.01.18.
//  Copyright © 2018 bcye. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//moved out of VC in refactor
class BookFetchedResultsController: NSFetchedResultsController<Book>, NSFetchedResultsControllerDelegate {
    private let tableVC: UITableViewController
    private var tableView: UITableView
    var changedContent = false
    
    //takes tableView (to update) and fetches
    init(moc: NSManagedObjectContext, tableViewController: UITableViewController) {
        self.tableVC = tableViewController
        tableView = tableVC.tableView
        super.init(fetchRequest: Book.fetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        self.delegate = self
        
        tryFetch()
    }

    //fetch function called in init
    func tryFetch () {
        do {
            try performFetch()
        } catch {
            error.alert(with: tableVC, error: .frcFetchFailed)
            print("Error: \(error)")
        }
    }
    
    //MARK: Fetched Results Controller Delegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        changedContent = true
    }


}

