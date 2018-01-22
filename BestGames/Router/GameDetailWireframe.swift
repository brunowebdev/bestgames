//
//  GameDetailWireframe.swift
//  BestGames
//
//  Created by Bruno Alves on 22/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import Foundation
import UIKit

protocol GameDetailWireframeProtocol:class {
    static func createGameDetailModule(forGame game: GameEntity) -> UIViewController
}

class GameDetailWireframe: GameDetailWireframeProtocol {
    
    class func createGameDetailModule(forGame game: GameEntity) -> UIViewController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "GameDetailViewController")
        if let view = viewController as? GameDetailViewController {
            
            
            let presenter: GameDetailPresenterProtocol = GameDetailPresenter()
            let wireframe: GameDetailWireframeProtocol = GameDetailWireframe()
            
            view.presenter = presenter
            presenter.view = view
            presenter.game = game
            presenter.wireframe = wireframe
            
            return viewController
        }
        return UIViewController()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
