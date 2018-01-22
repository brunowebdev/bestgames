//
//  GameListCollectionViewController.swift
//  BestGames
//
//  Created by Bruno Alves on 20/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import UIKit
import PKHUD
import Reachability

protocol GameListCollectionViewProtocol: class {
    func showGameListData(games: [GameEntity])
}

class GameListCollectionViewController: UICollectionViewController, GameListCollectionViewProtocol {
    
    var presenter: GameListPresenterProtocol!
    var games: [GameEntity] = []
    var loadingMoreData:Bool = false
    
    var dataTest:[String] = []
    var refresher:UIRefreshControl!
    let reachability = Reachability()!
    var reachabilityStartChecked:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(connectionChangedStatus(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func connectionChangedStatus(note: Notification) {
        let reachability = note.object as! Reachability
        
        if self.reachabilityStartChecked {
            switch reachability.connection {
            case .wifi:
                HUD.flash(.label("Conexão restaurada!"), delay: 2.0) { _ in
                }
            case .cellular:
                HUD.flash(.label("Conexão restaurada!"), delay: 2.0) { _ in
                }
            case .none:
                HUD.flash(.label("Conexão indisponível!"), delay: 2.0) { _ in
                }
            }
        }else{
            self.reachabilityStartChecked = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show(.progress)
        self.presenter.updateView()
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.blue
        refresher.addTarget(self, action: #selector(self.updateGames), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView!.refreshControl = refresher
        } else {
            collectionView?.addSubview(refresher)
        }
    }
    
    @objc func updateGames(){
        HUD.show(.progress)
        self.presenter.updateGames()
    }
    
    func showGameListData(games: [GameEntity]) {
        self.games = games
        self.loadingMoreData = false
        self.collectionView?.reloadData()
        refresher.endRefreshing()
        HUD.hide()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.games.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameListCollectionViewCell
        cell.name.text = self.games[indexPath.row].name
        cell.thumbnail.af_setImage(withURL: URL(string: self.games[indexPath.row].thumbnail)!)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.showGameDetail(forGame: self.games[indexPath.row])
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !loadingMoreData {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            if offsetY == contentHeight - scrollView.frame.size.height {
                HUD.show(.progress)
                loadingMoreData = true
                self.presenter.updateView()
                self.collectionView?.reloadData()
            }
        }
    }
}

