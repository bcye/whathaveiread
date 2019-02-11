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
import CloudCore

class CoreDataStack {

    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WHIR")
        
        // offline capabilities
        let storeDescription = container.persistentStoreDescriptions.first
        storeDescription?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                // TODO: Find way to alert the user from here
                print(error)
            }
        }
        
        container.performBackgroundTask { moc in
            moc.name = CloudCore.config.pushContextName
            // make changes to objects, properties, and relationships you want pushed via CloudCore
            try? self.managedObjectContext.save()
        }
        return container
    }()
    
    func enableCloudCore() {
        CloudCore.enable(persistentContainer: persistentContainer)
    }
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
