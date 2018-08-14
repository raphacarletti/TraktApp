//
//  ShowsCollectionViewCell.swift
//  TraktApp
//
//  Created by Raphael Carletti on 2018-08-13.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

class ShowsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var showNameLabel: UILabel! {
        didSet {
            self.showNameLabel.textColor = UIColor.secondGrey
        }
    }
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            self.posterImageView.contentMode = .scaleAspectFit
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(show: Show) {
        self.showNameLabel.text = show.title
        if let image = show.image {
            self.posterImageView.image = image
        } else {
            self.posterImageView.image = ImageConstants.imagePlaceholder
            ShowsAPIService.getSharedInstance().getTMDBShow(show: show) { (success) in
                ImageAPIService.getSharedInstance().getMovieImage(show: show, completion: { (image) in
                    self.posterImageView.image = image
                })
            }
        }
    }
}
