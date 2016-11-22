//
//  StopwatchPersistence.swift
//  Stopwatch
//
//  Created by Aditya Karnam Gururaj Rao on 11/20/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import Foundation
import CoreData

class StopwatchPersistence {
    private let context: NSManagedObjectContext
    
    init() {
        let coreDataManager = CoreDataManager.sharedManager()
        self.context = coreDataManager.managedObjectContext
    }
    
    func fetchLapsData() -> [Double] {
        let entity = NSEntityDescription.entity(forEntityName: "LapsDataTable", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.propertiesToFetch = [(entity?.propertiesByName["lapTime"])!]
        
        do {
            var timeStamps = [Double]()
            let results = try context.fetch(fetchRequest)
            
            for timeStamp in results {
                timeStamps.append((timeStamp as AnyObject).value(forKey: "lapTime") as! Double)
            }
            return timeStamps
        } catch {
            return []
        }
    }
    
    func storeLapData (lapNumber: Int, lapTimeInterval: Double) {
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "LapsDataTable", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(lapNumber, forKey: "lapSNo")
        transc.setValue(lapTimeInterval, forKey: "lapTime")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func deleteLapsData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LapsDataTable")
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for entity in results {
                context.delete(entity)
            }
            try context.save()
        } catch {
            
        }
        
        
    }
    
}
