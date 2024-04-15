//
//  DataManagerRepository.swift
//  Speedtest
//
//  Created by Rodion on 15.04.2024.
//

import Foundation
import CoreData

// Оберетка для использования DataManager в других классах
protocol DataManagerRepositoryLogic {
    func saveObject<T: NSManagedObject>(_ objectType: T.Type, properties: [String: Any])
    func fetchObjects<T: NSManagedObject>(_ objectType: T.Type) -> [T]
}

final class DataManagerRepository: DataManagerRepositoryLogic {
    private let dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }

    func saveObject<T>(_ objectType: T.Type, properties: [String : Any]) where T : NSManagedObject {
        dataManager.saveObject(objectType, properties: properties)
    }
    
    func fetchObjects<T>(_ objectType: T.Type) -> [T] where T : NSManagedObject {
        dataManager.fetchObjects(objectType)
    }
}
