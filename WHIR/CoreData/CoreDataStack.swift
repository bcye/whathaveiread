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

    func migrateToSeamStore() {
       
        // store references to URLs necessary for migration
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let oldUrl = documentDirectory.appendingPathComponent("WHIR.sqlite")
        let newUrl = documentDirectory.appendingPathComponent("WHIR-Seam.sqlite")
        let modelUrl = Bundle.main.url(forResource: "WHIR", withExtension: "momd")
        
        if let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl!) {
            let container = NSPersistentContainer(name: "migrationContainer", managedObjectModel: managedObjectModel)
            let coordinator = container.persistentStoreCoordinator
            
            guard let _ = try? coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: oldUrl, options: nil), let oldStore = coordinator.persistentStore(for: oldUrl) else {
                fatalError("Failed to reference or create old store")
            }
            
            do {
                SMStore.registerStoreClass()
                SMStore.syncAutomatically = false
                try coordinator.migratePersistentStore(oldStore, to: newUrl, options:nil, withType:SMStore.type)
                verifyCloudKitAuth()
                self.smStore?.triggerSync()
                SMStore.syncAutomatically = true
            } catch {
                fatalError("Failed to migrate store: \(error)")
            }
        }
        
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let applicationDocumentsDirectory = urls.last {
            
            let url = applicationDocumentsDirectory.appendingPathComponent("WHIR-Seam.sqlite")
            let seamStoreExists = FileManager.default.fileExists(atPath: url.path)
            
            if !seamStoreExists {
                migrateToSeamStore()
            } else {
                let container = NSPersistentContainer(name: "WHIR-Seam")
                let coordinator = container.persistentStoreCoordinator
                
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
        }
        
        fatalError("Unable to access documents directory")
        
    }()
    
    func verifyCloudKitAuth() {
        self.smStore?.verifyCloudKitConnectionAndUser() { (status, user, error) in
            guard status == .available, error == nil else {
                NSLog("Unable to verify CloudKit Connection \(error)")
                return
            }
            
            guard let currentUser = user else {
                NSLog("No current CloudKit user")
                return
            }
            
            var completeSync = false
            
            let previousUser = UserDefaults.standard.string(forKey: "CloudKitUser")
            if  previousUser != currentUser {
                do {
                    print("New user")
                    try self.smStore?.resetBackingStore()
                    completeSync = true
                } catch {
                    NSLog("Error resetting backing store - \(error.localizedDescription)")
                    return
                }
            }
            
            UserDefaults.standard.set(currentUser, forKey:"CloudKitUser")
            
            self.smStore?.triggerSync(complete: completeSync)
        }
    }
    
    init() {
        self.smStore = persistentContainer.persistentStoreCoordinator.persistentStores.first as? SMStore
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
