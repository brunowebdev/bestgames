//
//  GameRemoteDataManager.swift
//  BestGames
//
//  Created by Bruno Alves on 21/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

protocol GameRemoteDataManagerInputProtocol: class {
    var remoteRequestHandler: GameRemoteDataManagerOutputProtocol? { get set }
    func retrieveGameList(url:String)
}

class GameRemoteDataManager: GameRemoteDataManagerInputProtocol {
    
    var remoteRequestHandler: GameRemoteDataManagerOutputProtocol?
    
    func retrieveGameList(url: String) {
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Client-ID": API.ClientID]).responseJSON { (response) in
            
            if response.result.isFailure {
                self.remoteRequestHandler?.onError()
            }else{
                if let json = response.result.value {
                    let parsedJson = JSON(json)
                    let next = parsedJson["_links"]["next"].string!
                    var games:[GameEntity] = []
                    
                    for (index,subJson):(String, JSON) in JSON(parsedJson["top"]) {
                        games.append(GameEntity(id: subJson["game"]["_id"].int!, name: subJson["game"]["name"].string!, channels: subJson["channels"].int!, viewers: subJson["viewers"].int!, thumbnail: subJson["game"]["box"]["large"].string!))
                    }
                    
                    self.remoteRequestHandler?.didRetrieveGames(games, nextPage: next)
                }
            }
        }
    }
}
