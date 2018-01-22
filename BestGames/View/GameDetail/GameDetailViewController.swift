//
//  GameDetailViewController.swift
//  BestGames
//
//  Created by Bruno Alves on 22/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import UIKit

protocol GameDetailViewProtocol: class {
    var presenter: GameDetailPresenterProtocol? { get set }
    
    func showGameDetail(forGame game: GameEntity)
}

class GameDetailViewController: UIViewController, GameDetailViewProtocol {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var channels: UILabel!
    @IBOutlet weak var viewers: UILabel!
    
    var presenter: GameDetailPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showGameDetail(forGame game: GameEntity) {
        name?.text = game.name
        thumbnail.af_setImage(withURL: URL(string: game.thumbnail)!)
        channels.text = String(game.channels)
        viewers.text = String(game.viewers)
    }
}
