//
//  CoreDataStack.swift
//  WHIR
//
//  Created by Bruce Röttgers on 14.02.18.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Seam3

class CoreDataStack {

    var smStore: SMStore?
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WHIR")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                // TODO: Find way to alert the user from here
                print(error)
            }
        }
        return container
    }()
    
    private lazy var smPersistentContainer: NSPersistentContainer = {
        
        SMStore.registerStoreClass()
        
        let container = NSPersistentContainer(name: "WHIR-Seam")
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let applicationDocumentsDirectory = urls.last {
            
            let url = applicationDocumentsDirectory.appendingPathComponent("WHIR-Seam.sqlite")
            
            let storeDescription = NSPersistentStoreDescription(url: url)
            
            storeDescription.type = SMStore.type
            
            container.persistentStoreDescriptions=[storeDescription]
            
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }
        
        fatalError("Unable to access documents directory")
        
    }()
}

//extension to saveChanges in managedObjectCOntext
extension NSManagedObjectContext {
    func saveChanges(viewController: UIViewController) {
        if self.hasChanges {
            do {
                try save()
            } catch {
                ErrorCases.saveFailed.alert(with: viewController)
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

//all classes that allow the main vc to set their moc
//so prepareForSegue Can be used
protocol ManagedObjectContextSettable {

    var managedObjectContext: NSManagedObjectContext! { get set }

}
