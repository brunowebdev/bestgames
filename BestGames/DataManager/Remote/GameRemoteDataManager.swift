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
    //var clearDb:Bool!
    
    func retrieveGameList(url: String) {
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Client-ID": "i956f46goi35c3xc054c948shm3snl"]).responseJSON { (response) in
            
            if let json = response.result.value {
                let parsedJson = JSON(json)
                let next = parsedJson["_links"]["next"].string!
                var games:[GameEntity] = []
                
                for (index,subJson):(String, JSON) in JSON(parsedJson["top"]) {
                    games.append(GameEntity(id: subJson["game"]["_id"].int!, name: subJson["game"]["name"].string!, channels: subJson["channels"].int!, viewers: subJson["viewers"].int!, thumbnail: subJson["game"]["box"]["large"].string!))
                }
                
                self.remoteRequestHandler?.didRetrieveGames(games, nextPage: next)
                
//                self.clearDb = self.url == Endpoints.topGames.url
//                self.url = parsedJson["_links"]["next"].string as! String
//                self.remoteRequestHandler?.didRetrieveGames(games, resetDataBase: self.clearDb)
            }
        }
        
        /*
        Alamofire.request(url).responseJSON { (response) in
            
            if let json = response.result.value {
                NSLog("\(json)")
                let games:[GameEntity] = []
                self.remoteRequestHandler?.didRetrieveGames(games)
            }
            
        }
        */
        
        //Callback
        
    }
    
}
