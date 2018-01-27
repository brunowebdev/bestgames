//
//  GameListCollectionViewController.swift
//  BestGames
//
//  Created by Bruno Alves on 20/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import Reachability

protocol GameListCollectionViewProtocol: class {
    func showGameListData(games: [GameEntity])
    func gameListError()
}

class GameListCollectionViewController: UICollectionViewController, GameListCollectionViewProtocol {
    
    var presenter: GameListPresenterProtocol!
    var games: [GameEntity] = []
    var loadingMoreData:Bool = false
    
    var dataTest:[String] = []
    var refresher:UIRefreshControl!
    let reachability = Reachability()!
    var reachabilityStartChecked:Bool = false
    
    func registerRefresher(){
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = UIColor.blue
        self.refresher.addTarget(self, action: #selector(self.updateGames), for: .valueChanged)
        
        collectionView?.refreshControl = self.refresher
    }
    
    func unregisterRefresher(){
        collectionView?.refreshControl = nil
    }
    
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
                    self.registerRefresher()
                }
            case .cellular:
                HUD.flash(.label("Conexão restaurada!"), delay: 2.0) { _ in
                    self.registerRefresher()
                }
            case .none:
                HUD.flash(.label("Conexão indisponível!"), delay: 2.0) { _ in
                    self.unregisterRefresher()
                }
            }
        }else{
            self.reachabilityStartChecked = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show(.progress)
        if (NetworkReachabilityManager()?.isReachable)! {
            self.registerRefresher()
        }
        self.presenter.viewDidLoad()
    }
    
    @objc func updateGames(){
        HUD.show(.progress)
        self.presenter.updateGames()
    }
    
    func showGameListData(games: [GameEntity]) {
        self.games = games
        self.loadingMoreData = false
        self.collectionView?.reloadData()
        if (NetworkReachabilityManager()?.isReachable)! {
            refresher.endRefreshing()
        }
        HUD.hide()
    }
    
    func gameListError(){
        HUD.hide()
        HUD.flash(.label("Ooops!\nO download dos jogos falhou! :("), delay: 2.0) { _ in
            self.registerRefresher()
        }
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

