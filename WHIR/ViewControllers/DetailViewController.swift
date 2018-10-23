//
//  DetailViewController.swift
//  WHIR
//
//  Created by Bruce Röttgers on 04.04.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, ManagedObjectContextSettable {

    // #warning: watch last part of CoreData course on Treehouse to understand how to show Detail stuff from TableView w/ Coredata (!!!)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryView: UITextView!
    var book: Book!
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Display the book
        titleLabel.text = book.title
        summaryView.text = book.summary
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

            // dismiss self after changes were made
            self.dismiss(animated: true, completion: nil)
        } else {
            // alert the user they haven't changed anything
            let title = NSLocalizedString("noChangesAlertTitle", comment: "There are no changes!")
            let message = NSLocalizedString("noChangesAlertMessage", comment: "Whoops! Looks like you tried to save without making changes. Go back or change text by clicking it before saving!")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
