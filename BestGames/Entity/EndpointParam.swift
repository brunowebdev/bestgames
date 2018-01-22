//
//  EndpointParam.swift
//  BestGames
//
//  Created by Bruno Alves on 22/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation
import ObjectMapper

struct EndpointParamEntity {
    var param = ""
}

extension EndpointParamEntity: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        param <- map["param"]
    }
}

