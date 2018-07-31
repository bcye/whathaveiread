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
        // Do any additional setup after loading the view.
        
        //Display the book
        titleLabel.text = book.title
        summaryView.text = book.summary
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBook(_ sender: Any) {
        managedObjectContext.delete(book)
        managedObjectContext.saveChanges(viewController: self)
        dismiss(animated: true, completion: nil)
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
            let alert = UIAlertController(title: "There are no changes!", message: "Whoops! Looks like you tried to save without making changes. Go back or change text by clicking it before saving!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
}
