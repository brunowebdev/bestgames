//
//  GameListRouter.swift
//  BestGames
//
//  Created by Bruno Alves on 20/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation
import UIKit

protocol GameListWireframeProtocol:class {
    static func createGameListViewModule() -> UIViewController
    func presentGameDetailScreen(from view: GameListCollectionViewProtocol, forGame game: GameEntity)
}

class GameListWireframe: GameListWireframeProtocol {
    
    class func createGameListViewModule() -> UIViewController {
        
        let navController = mainStoryboard.instantiateViewController(withIdentifier: "RootNavigationController")
        
        if let view = navController.childViewControllers.first as? GameListCollectionViewController {
            
            let presenter: GameListPresenterProtocol & GameInteractorOutputProtocol = GameListPresenter()
            let interactor: GameInteractorInputProtocol & GameRemoteDataManagerOutputProtocol = GameInteractor()
            let gameLocalDataManager: GameLocalDataManagerInputProtocol = GameLocalDataManager()
            let endpointParamLocalDataManager: EndpointParamLocalDataManagerInputProtocol = EndpointParamLocalDataManager()
            let gameRemoteDataManager: GameRemoteDataManagerInputProtocol = GameRemoteDataManager()
            let wireframe: GameListWireframeProtocol = GameListWireframe()
            
            view.presenter = presenter
            presenter.view = view

            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.gameLocalDataManager = gameLocalDataManager
            interactor.endpointParamLocalDataManager = endpointParamLocalDataManager
            interactor.gameRemoteDataManager = gameRemoteDataManager
            gameRemoteDataManager.remoteRequestHandler = interactor
            
            
            return navController
        }
        return GameListCollectionViewController()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func presentGameDetailScreen(from view: GameListCollectionViewProtocol, forGame game: GameEntity) {
        let gameDetailViewController = GameDetailWireframe.createGameDetailModule(forGame: game)
        
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(gameDetailViewController, animated: true)
        }
    }
    
}
