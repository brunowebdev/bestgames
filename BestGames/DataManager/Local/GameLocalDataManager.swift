//
//  GameLocalDataManager.swift
//  BestGames
//
//  Created by Bruno Alves on 21/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import CoreData

protocol GameLocalDataManagerInputProtocol:class {
    func retrieveGameList() throws -> [Game]
    func saveGame(id: Int, name: String, thumbnail: String, channels: Int, viewers: Int) throws
    func resetGameData()
}

class GameLocalDataManager: GameLocalDataManagerInputProtocol {
    
    func retrieveGameList() throws -> [Game] {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<Game> = NSFetchRequest(entityName: "Game")
        
        return try managedOC.fetch(request)
    }
    
    func saveGame(id: Int, name: String, thumbnail: String, channels: Int, viewers: Int) throws {
        
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        if let newGame = NSEntityDescription.entity(forEntityName: "Game", in: managedOC) {
            let gameObject = Game(entity: newGame, insertInto: managedOC)
            gameObject.id = Int32(id)
            gameObject.name = name
            gameObject.thumbnail = thumbnail
            gameObject.channels = Int32(channels)
            gameObject.viewers = Int32(viewers)
            try managedOC.save()
        }
        throw PersistenceError.couldNotSaveObject
    }
    
    func resetGameData() {
        do {
            guard let managedOC = CoreDataStore.managedObjectContext else {
                throw PersistenceError.managedObjectContextNotFound
            }
            
            let request: NSFetchRequest<Game> = NSFetchRequest(entityName: "Game")
            let items = try managedOC.fetch(request)
            
            for item in items {
                managedOC.delete(item)
            }
            try managedOC.save()
            
        } catch {
            
        }
    }
}

