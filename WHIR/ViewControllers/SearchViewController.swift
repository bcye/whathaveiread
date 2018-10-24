//
//  SearchViewController.swift
//  WHIR
//
//  Created by Bruce Röttgers on 05.04.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, ManagedObjectContextSettable, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    //Variables, constants, Outlets, etc.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    var managedObjectContext: NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
        var fetchRequest: NSFetchRequest<Book> = NSFetchRequest<Book>(entityName: "Book")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return NSFetchedResultsController<Book>(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }()

    private func search() {
        guard let searchPhrase = searchField.text else { return }

        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "title contains[cd] %@", searchPhrase)

        do {
            try fetchedResultsController.performFetch()
        } catch {
         fatalError("Error: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        searchField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func keyboardWillDisappear() {
        print("will disappear")
        search()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        let book = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = book.title
        return cell
    }
}
