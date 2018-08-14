//
//  ViewController.swift
//  TraktApp
//
//  Created by Raphael Carletti on 2018-08-13.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController {
    @IBOutlet weak var showsCollectionView: UICollectionView! {
        didSet {
            self.showsCollectionView.dataSource = self
            self.showsCollectionView.delegate = self
            self.showsCollectionView.register(ShowsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ShowsCollectionViewCell.self))
            
            self.showsCollectionView.register(UINib(nibName: String(describing: ShowsCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ShowsCollectionViewCell.self))
        }
    }
    
    var shows: [Show] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavBar()
        ShowsAPIService.getSharedInstance().getPopularShows { (shows) in
            if let shows = shows {
                self.shows.append(contentsOf: shows)
                self.showsCollectionView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func configNavBar() {
        self.title = "Shows"
        self.navigationController?.navigationBar.barTintColor = UIColor.primaryOrange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
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
    
}

