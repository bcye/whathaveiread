//
//  Book+CoreDataProperties.swift
//  
//
//  Created by Bruce Röttgers on 04.04.18.
//
//

import Foundation
import CoreData

extension Book {

    public class func fetchRequest() -> NSFetchRequest<Book> {
        let request = NSFetchRequest<Book>(entityName: "Book")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return request
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
}
