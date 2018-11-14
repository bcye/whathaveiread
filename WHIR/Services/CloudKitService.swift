//
//  CloudKitService.swift
//  WHIR
//
//  Created by Bruce Roettgers on 2018-11-13.
//  Copyright © 2018 Dirk Hulverscheidt. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitService {
    
    // where all the application data is stored
    lazy var container = CKContainer.default()
    
    // reference to the private database (only accesible by user)
    lazy var privateDatabase = container.privateCloudDatabase
    
    func createRecord(of book: Book) -> CKRecord {
        
        // initialize record
        let recordId = CKRecord.ID(recordName: book.title)
        let record = CKRecord(recordType: "Book", recordID: recordId)
        
        // assign values to record
        record["title"] = book.title
        record["date"] = book.date
        if let description = book.summary {
            record["description"] = description
        }
        
        return record
    }
    
    func upload(record: CKRecord, errorCallback: @escaping (Error) -> Void) {
        privateDatabase.save(record) { (record, error) in
            if let error = error {
                errorCallback(error)
            }
        }
    }
    
}
