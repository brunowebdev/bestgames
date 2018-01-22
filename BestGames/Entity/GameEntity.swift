//
//  GameEntity.swift
//  BestGames
//
//  Created by Bruno Alves on 19/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation
import ObjectMapper

struct GameEntity {
    var id = 0
    var name = ""
    var channels = 0
    var viewers = 0
    var thumbnail = ""
}

extension GameEntity: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        thumbnail <- map["thumbnail"]
        channels <- map["channels"]
        viewers <- map["viewers"]
    }
}

