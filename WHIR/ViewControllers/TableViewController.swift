//
//  TableViewController.swift
//  WHIR
//
//  Created by Bruce Röttgers on 14.02.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    // MARK: Variables, IBOutlets, etc.
    @IBOutlet weak var navBar: UINavigationItem!
    let managedObjectContext = CoreDataStack().managedObjectContext
    lazy var fetchedResultsController: BookFetchedResultsController = {
         return BookFetchedResultsController(moc: self.managedObjectContext, tableViewController: self)
    }()

    //Shows count of books in the nav bar
    override func viewDidLoad() {
        super.viewDidLoad()

        setupIntents()
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
        switch segue.identifier {
        case "addItem", "showSummary", "showSearch":
            guard
                let navigationController = segue.destination as? UINavigationController,
                var addTransactionController = navigationController.topViewController as? ManagedObjectContextSettable else {
                    return
            }

            addTransactionController.managedObjectContext = self.managedObjectContext
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

    // MARK: Barcode
    @IBAction func addByBarcode(_ sender: Any) {
        // creates the scanner view controller, sets delegates and presents it.
        let scanner = BarcodeScannerViewController()
//        scanner.dismissalDelegate = self
//        scanner.codeDelegate = self
//        scanner.errorDelegate = self

        present(scanner, animated: true, completion: nil)
    }

    func searchBookForCode(code: String) {
        OpenLibraryService.search(ISBN: code) { [weak self] (openLibraryBook, error) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }

                // Manage error
                if let error = error {
                    error.alert(with: strongSelf)
                    return
                }

                // create item
                guard let book = openLibraryBook else { return }

                let item = NSEntityDescription.insertNewObject(forEntityName: "Book", into: strongSelf.managedObjectContext) as? Book
                item?.title = book.details.title
                item?.summary = dump(book.details.desc)
                item?.date = NSDate()

                // save to core data
                strongSelf.managedObjectContext.saveChanges(viewController: strongSelf)

                // try to display review prompt
                MarketingAlertHelper().tryToDisplayPrompts(with: strongSelf)
            }
        }
    }
}

// MARK: - BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate

//extension TableViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
//
//    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
//        searchBookForCode(code: code)
//
//        // return to the previous ViewController
//        controller.reset()
//        controller.dismiss(animated: true, completion: nil)
//    }
//
//    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//
//    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
//        print(error)
//    }
//}
