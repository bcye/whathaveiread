//
//  TableViewController.swift
//  WHIR
//
//  Created by Bruce Röttgers on 14.02.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Sentry

class TableViewController: UITableViewController {

    let defaults = UserDefaults.standard
    
    // MARK: Variables, IBOutlets, etc.
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet var barcodeScannerButton: UIBarButtonItem!
    let managedObjectContext = CoreDataStack().managedObjectContext
    lazy var fetchedResultsController: BookFetchedResultsController = {
         return BookFetchedResultsController(moc: self.managedObjectContext, tableViewController: self)
    }()

    //Shows count of books in the nav bar
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIntents()
        
        if !defaults.bool(forKey: "sentryAsked") {
            self.performSegue(withIdentifier: "askForSentryPermission", sender: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        renderBarcodeScannerButton()
    }

    func renderBarcodeScannerButton() {
        if case .restricted = AVCaptureDevice.authorizationStatus(for: .video), let index = navBar.rightBarButtonItems?.firstIndex(of: barcodeScannerButton) {
            navBar.rightBarButtonItems?.remove(at: index)
        } else if let rightItems = navBar.rightBarButtonItems, !rightItems.contains(barcodeScannerButton) {
            navBar.rightBarButtonItems?.insert(barcodeScannerButton, at: rightItems.startIndex)
        }
    }

    func setupIntents() {
        let activity = NSUserActivity(activityType: "dirkhulverscheidt.WHIR.addBook")
        activity.title = NSLocalizedString("addBook", comment: "Add Book")
        activity.userInfo = [ : ]
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        } else {
            // Fallback on earlier versions
        }
        view.userActivity = activity
        activity.becomeCurrent()
    }

    public func addBook() {
        self.performSegue(withIdentifier: "addItem", sender: self)
    }

    //passes moc through to addviewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case "addItem", "showSummary", "showSearch":
            guard
                let navigationController = segue.destination as? UINavigationController,
                var addTransactionController = navigationController.topViewController as? ManagedObjectContextSettable else {
                    return
            }

            addTransactionController.managedObjectContext = self.managedObjectContext
        case "presentScanner":
            guard
                let navigator = segue.destination as? UINavigationController,
                let scanner = navigator.topViewController as? BarcodeScannerViewController else {
                return
            }
            scanner.delegate = self
        default:
            print("Another identifier was used: \(String(describing: segue.identifier))")
        }

        if segue.identifier == "showSummary" {
            guard
                let navViewController = segue.destination as? UINavigationController,
                let detailVC = navViewController.topViewController as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
                else {
                    return
            }

            let book = fetchedResultsController.object(at: indexPath)
            detailVC.book = book
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return configureCell(cell, at: indexPath)
    }

    // to configure cell, is called in tableView cellForRowAt
    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) -> UITableViewCell {
        let book = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = book.title
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let book = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(book)
        managedObjectContext.saveChanges(viewController: self)
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

// MARK: - ISBNScannerDelegate

extension TableViewController: ISBNScannerDelegate {
    func scanner(_ scanner: BarcodeScannerViewController, didCaptureISBN isbn: String) {
        scanner.stopScanning()
        let hapticFeedback = UINotificationFeedbackGenerator()
        DispatchQueue.main.async {
            hapticFeedback.prepare()
            hapticFeedback.notificationOccurred(.success)
        }

        let animationTime = DispatchTime.now() + 1

        GBooksService.search(isbn: isbn) { [weak self] (book, error) in
            DispatchQueue.main.async {

                guard let strongSelf = self else { return }

                // Manage error
                if error == nil {
                    // create item
                    guard let book = book else { return }

                let item = NSEntityDescription.insertNewObject(forEntityName: "Book", into: strongSelf.managedObjectContext) as? Book
                item?.title = book.title
                item?.summary = book.description
                item?.date = NSDate()

                    // save to core data
                    strongSelf.managedObjectContext.saveChanges(viewController: strongSelf)
                }

                DispatchQueue.main.asyncAfter(deadline: animationTime, execute: { // Wait at least a second for dramatic effect
                    scanner.dismiss(animated: true, completion: {
                        // Display error if necessary
                        if let error = error {
                            error.alert(with: strongSelf)
                        } else {
                            // try to display review prompt
                            MarketingAlertHelper().tryToDisplayPrompts(with: strongSelf)
                        }
                    })
                })
            }
        }
    }
}
