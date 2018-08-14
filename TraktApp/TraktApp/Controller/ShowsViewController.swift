//
//  ViewController.swift
//  TraktApp
//
//  Created by Raphael Carletti on 2018-08-13.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController {
    @IBOutlet private weak var showsCollectionView: UICollectionView! {
        didSet {
            self.showsCollectionView.dataSource = self
            self.showsCollectionView.delegate = self
            self.showsCollectionView.register(ShowsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ShowsCollectionViewCell.self))
            self.showsCollectionView.register(UINib(nibName: String(describing: ShowsCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ShowsCollectionViewCell.self))
            
        }
    }
    
    private var refresher = UIRefreshControl()
    
    private var shows: [Show] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavBar()
        self.configPullToRefresh()
        self.getAllShows()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAllShows(completion: (()->())? = nil) {
        ShowsAPIService.getSharedInstance().getPopularShows { (shows) in
            if let shows = shows {
                self.shows.append(contentsOf: shows)
                self.showsCollectionView.reloadData()
            } else {
                let alert = UIAlertController(title: AlertMessages.cantLoadShows , message: AlertMessages.cantLoadShowsSubtitle, preferredStyle: .alert)
                let action = UIAlertAction(title: AlertMessages.ok, style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            completion?()
        }
    }

    func configNavBar() {
        self.title = "Shows"
        self.navigationController?.navigationBar.barTintColor = UIColor.primaryOrange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
    }
    
    func configPullToRefresh() {
        self.refresher.tintColor = UIColor.black
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.showsCollectionView.alwaysBounceVertical = true
        self.showsCollectionView.addSubview(refresher)
    }
    
    @objc func loadData() {
        if ShowsAPIService.getSharedInstance().canPullToRefresh() {
            self.shows = []
            ShowsAPIService.getSharedInstance().restartPopularShows()
            self.getAllShows {
                self.refresher.endRefreshing()
            }
        } else {
            self.refresher.endRefreshing()
        }
    }

}

extension ShowsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowsCollectionViewCell.self), for: indexPath) as? ShowsCollectionViewCell {
            let show = self.shows[indexPath.row]
            cell.setUpCell(show: show)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension ShowsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/3 - Spacing.collectionViewSpace, height: collectionView.bounds.size.height/3 - Spacing.collectionViewSpace)
    }
}

extension ShowsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (self.shows.count-1) && ShowsAPIService.getSharedInstance().canLoadMore() {
            self.getAllShows()
        }
    }
}

