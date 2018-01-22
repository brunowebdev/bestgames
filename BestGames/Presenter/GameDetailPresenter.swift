//
//  GameDetailPresenter.swift
//  BestGames
//
//  Created by Bruno Alves on 22/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation

protocol GameDetailPresenterProtocol: class {
    var view: GameDetailViewProtocol? { get set }
    var wireframe: GameDetailWireframeProtocol? { get set }
    var game: GameEntity? { get set }
    
    func viewDidLoad()
}

class GameDetailPresenter: GameDetailPresenterProtocol {
    
    weak var view: GameDetailViewProtocol?
    var wireframe: GameDetailWireframeProtocol?
    var game: GameEntity?
    
    func viewDidLoad() {
        view?.showGameDetail(forGame: game!)
    }
}
