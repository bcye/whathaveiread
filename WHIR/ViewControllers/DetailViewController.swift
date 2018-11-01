//
//  DetailViewController.swift
//  WHIR
//
//  Created by Bruce Röttgers on 04.04.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit
import CoreData
import KMPlaceholderTextView

class DetailViewController: UIViewController, ManagedObjectContextSettable {

    // #warning: watch last part of CoreData course on Treehouse to understand how to show Detail stuff from TableView w/ Coredata (!!!)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryView: KMPlaceholderTextView!
    var book: Book!
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Display the book
        titleLabel.text = book.title
        summaryView.text = book.summary
        summaryView.placeholder = NSLocalizedString("summarizeBookPlaceholder", comment: "You have plenty of space to summarize the book here. Use it!")
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteBook(_ sender: Any) {
        managedObjectContext.delete(book)
        managedObjectContext.saveChanges(viewController: self)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func shareBook(_ sender: Any) {
        var objectsToShare = [Any]()
        let message = NSLocalizedString("shareBookMessage", comment: "I just read this book and wanted to share it with you. \n")
        let postScriptum = NSLocalizedString("sharePostScriptum", comment: "P.S:You can write down summaries for your books too with this app: http://bit.ly/whirshare")
        objectsToShare.append(message)
        if let title = book.title {
            objectsToShare.append(title + " \n")
        }
        if let summary = book.summary {
            objectsToShare.append(summary + " \n")
        }

        objectsToShare.append(postScriptum)
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }

    //check wether user edited the text, if so save the changes and dismiss
    @IBAction func saveChanges(_ sender: Any) {
        if summaryView.text != book.summary {
            // save changes
            book.summary = summaryView.text
            managedObjectContext.saveChanges(viewController: self)
        }

        // dismiss self after changes were made
        dismiss(animated: true, completion: nil)
    }
}
