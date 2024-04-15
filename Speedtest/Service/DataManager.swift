//
//  DataManager.swift
//  Speedtest
//
//  Created by Rodion on 14.04.2024.
//

import Foundation
import CoreData

// класс для сохранения и получения данных из CoreData
class DataManager {
    static let shared = DataManager()
    
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SpeedtestDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // Метод для сохранения всех объектов заданного типа в CoreData
    func saveObject<T: NSManagedObject>(_ objectType: T.Type, properties: [String: Any]) {
        let managedContext = persistentContainer.viewContext
        let entityName = String(describing: objectType)
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
            print("Failed to get entity description for \(entityName)")
            return
        }
        let object = T(entity: entity, insertInto: managedContext)

        for (key, value) in properties {
            object.setValue(value, forKey: key)
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    // Метод для получения всех объектов заданного типа из CoreData
    func fetchObjects<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: objectType))

        do {
            let objects = try managedContext.fetch(fetchRequest)
            return objects
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
}
