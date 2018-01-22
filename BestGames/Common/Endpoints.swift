//
//  Endpoint.swift
//  BestGames
//
//  Created by Bruno Alves on 20/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "https://api.twitch.tv/kraken"
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints: Endpoint {
    
    case topGames
    
    public var url: String {
        switch self {
        case .topGames: return "\(API.baseUrl)/games/top?limit=10"
        }
    }
}
