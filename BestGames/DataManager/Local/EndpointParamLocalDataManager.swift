//
//  EndpointParamLocalDataManager.swift
//  BestGames
//
//  Created by Bruno Alves on 22/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import CoreData

protocol EndpointParamLocalDataManagerInputProtocol:class {
    func retrieveParam() throws -> [EndpointParam]
    func saveParam(param: String) throws
    func resetEndpointParamData()
}

class EndpointParamLocalDataManager: EndpointParamLocalDataManagerInputProtocol {
    
    func retrieveParam() throws -> [EndpointParam] {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<EndpointParam> = NSFetchRequest(entityName: "EndpointParam")
        
        return try managedOC.fetch(request)
    }
    
    func saveParam(param:String) throws {
        
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        if let newParam = NSEntityDescription.entity(forEntityName: "EndpointParam", in: managedOC) {
            let paramObject = EndpointParam(entity: newParam, insertInto: managedOC)
            paramObject.param = param
            try managedOC.save()
        }
        throw PersistenceError.couldNotSaveObject
    }
    
    func resetEndpointParamData() {
        
        do {
            guard let managedOC = CoreDataStore.managedObjectContext else {
                throw PersistenceError.managedObjectContextNotFound
            }
            
            let request: NSFetchRequest<EndpointParam> = NSFetchRequest(entityName: "EndpointParam")
            let items = try managedOC.fetch(request)
            
            for item in items {
                managedOC.delete(item)
            }
            try managedOC.save()
            
        } catch {
            
        }
    }
}
