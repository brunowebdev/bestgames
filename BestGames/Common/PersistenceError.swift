//
//  PersistenceError.swift
//  BestGames
//
//  Created by Bruno Alves on 21/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation

enum PersistenceError: Error {
    case managedObjectContextNotFound
    case couldNotSaveObject
    case couldNotDeleteObject
    case objectNotFound
}
