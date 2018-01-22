//
//  GameListPresenter.swift
//  BestGames
//
//  Created by Bruno Alves on 20/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation
import Alamofire

protocol GameListPresenterProtocol: class {
    var view:GameListCollectionViewProtocol! { get set }
    var wireframe:GameListWireframeProtocol! { get set }
    var interactor: GameInteractorInputProtocol! { get set }
    
    func viewDidLoad()
    func updateView()
    func updateGames()
    
    func showGameDetail(forGame game: GameEntity)
}

protocol GameInteractorOutputProtocol:class {
    func gamesFetched(games:[GameEntity])
    func didReceivedError()
}

class GameListPresenter: GameListPresenterProtocol {
    
    weak var view: GameListCollectionViewProtocol!
    var interactor:GameInteractorInputProtocol!
    var wireframe: GameListWireframeProtocol!
    
    func viewDidLoad() {
        self.interactor.resetAndFetchGameList()
    }
    
    func updateView() {
        self.interactor.fetchGames()
    }
    
    func updateGames() {
        self.interactor.updateGames()
    }
    
    func showGameDetail(forGame game: GameEntity) {
        wireframe?.presentGameDetailScreen(from: view!, forGame: game)
    }
}

extension GameListPresenter: GameInteractorOutputProtocol {
    
    func gamesFetched(games: [GameEntity]) {
        if games.count > 0 {
            self.view.showGameListData(games: games)
        }
    }
    
    func didReceivedError() {
        NSLog("Error!")
    }
}

