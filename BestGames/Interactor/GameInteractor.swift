//
//  GameInteractor.swift
//  BestGames
//
//  Created by Bruno Alves on 20/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation
import Alamofire

protocol GameInteractorInputProtocol:class {
    var presenter:GameInteractorOutputProtocol? { get set }
    var gameLocalDataManager: GameLocalDataManagerInputProtocol? { get set }
    var endpointParamLocalDataManager: EndpointParamLocalDataManagerInputProtocol? { get set }
    var gameRemoteDataManager: GameRemoteDataManagerInputProtocol? { get set }
    
    func fetchGames()
    func updateGames()
}

protocol GameRemoteDataManagerOutputProtocol: class {
    func didRetrieveGames(_ games: [GameEntity], nextPage: String)
    func onError()
}

class GameInteractor: GameInteractorInputProtocol {
    
    weak var presenter: GameInteractorOutputProtocol?
    var gameLocalDataManager: GameLocalDataManagerInputProtocol?
    var endpointParamLocalDataManager: EndpointParamLocalDataManagerInputProtocol?
    var gameRemoteDataManager: GameRemoteDataManagerInputProtocol?
    var urlEndpointGameList:String!
    
    private func readEndpointParamFromDataBase(){
        do {
            if let endpointParam = try endpointParamLocalDataManager?.retrieveParam() {
                let endpointParamEntityList = endpointParam.map() {
                    return EndpointParamEntity(param: $0.param!)
                }
                if  endpointParamEntityList.isEmpty {
                    self.urlEndpointGameList = Endpoints.topGames.url
                }else{
                    self.urlEndpointGameList = endpointParam[0].param!
                }
            }
        } catch {
            //Catch exceptions
        }
    }
    
    private func readGameListFromDataBase(){
        do {
            if let gameList = try gameLocalDataManager?.retrieveGameList() {
                let gameEntityList = gameList.map() {
                    return GameEntity(id: Int($0.id), name: $0.name!, channels: Int($0.channels), viewers: Int($0.viewers), thumbnail: $0.thumbnail!)
                }
                if  gameEntityList.isEmpty {
                    gameRemoteDataManager?.retrieveGameList(url: self.urlEndpointGameList)
                }else{
                    self.presenter?.gamesFetched(games: gameEntityList)
                }
            } else {
                gameRemoteDataManager?.retrieveGameList(url: self.urlEndpointGameList)
            }
            
        } catch {
            //Catch exceptions
        }
    }
    
    func fetchGames() {
        if (NetworkReachabilityManager()?.isReachable)! {
            self.readEndpointParamFromDataBase()
            gameRemoteDataManager?.retrieveGameList(url: self.urlEndpointGameList)
        } else {
            self.readGameListFromDataBase()
        }
    }
    
    func updateGames() {
        if (NetworkReachabilityManager()?.isReachable)! {
            endpointParamLocalDataManager?.resetEndpointParamData()
            gameLocalDataManager?.resetGameData()
            
            self.readEndpointParamFromDataBase()
            gameRemoteDataManager?.retrieveGameList(url: self.urlEndpointGameList)
        } 
    }
}

extension GameInteractor: GameRemoteDataManagerOutputProtocol {
    func onError() {
        NSLog("Error")
    }
    
    func didRetrieveGames(_ games: [GameEntity], nextPage: String) {
        do {
            endpointParamLocalDataManager?.resetEndpointParamData()
            try endpointParamLocalDataManager?.saveParam(param: nextPage)
        }catch{
            //Unable to store data
        }
        
        //Save retrieved data on core data
        for game in games {
            do {
                try gameLocalDataManager?.saveGame(id: game.id, name: game.name, thumbnail: game.thumbnail, channels: game.channels, viewers: game.viewers)
            }catch{
                //Unable to store data
            }
        }
        
        self.readGameListFromDataBase()
    }
}
