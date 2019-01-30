//
//  VenuesCell.swift
//  EnvoyCoffee
//
//  Created by Kelvin Lee on 10/14/18.
//  Copyright © 2018 Kelvin Lee. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

class VenuesCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var checkinsLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 6.0
        self.imageView.clipsToBounds = true
        boxView.layer.cornerRadius = 6.0
        
        priceLabel.layer.cornerRadius = 6.0
        priceLabel.clipsToBounds = true
        
        isOpenLabel.layer.cornerRadius = 6.0
        isOpenLabel.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func setup(venue: Venue) {
        titleLabel.text = venue.name
        if venue.price.isEmpty {
            priceLabel.text = "Price unavailable"
        } else {
            priceLabel.text = venue.price
        }
        
        if venue.rating == 0 {
            ratingLabel.text = "Rating unavailable"
        } else {
            ratingLabel.text = String(venue.rating)
        }
        
        if venue.checkins == 0 {
            checkinsLabel.text = "Checkins unavailable"
        } else {
            checkinsLabel.text = String(venue.checkins)
        }
        
        if venue.isOpen {
            isOpenLabel.text = "Open"
        } else {
            isOpenLabel.text = "Closed"
        }
        locationLabel.text = venue.location.formattedAddress
        categoriesLabel.text = venue.categories.name
        checkinsLabel.text = String(venue.checkins)
        imageView.kf.indicatorType = .activity
        
        let placeHolder = UIImage()
        if let urlString = venue.photoUrl, let url = URL(string: urlString) {
            let imageResource = ImageResource(downloadURL: url)
            DispatchQueue.main.async {
                self.imageView.kf.setImage(with: imageResource, placeholder: placeHolder, options: [.transition(.fade(0.2))], progressBlock: { (received, total) in
                    debugPrint("Progress received:\(received), total:\(total)")
                }) { (result) in
                    switch result {
                    case .success(let value):
                        // The image was set to image view:
                        print(value.image)
                        self.imageView.image = value.image
                        // From where the image was retrieved:
                        // - .none - Just downloaded.
                        // - .memory - Got from memory cache.
                        // - .disk - Got from disk cache.
                        print(value.cacheType)
                        debugPrint("Image result:\(value.image), cache:\(value.cacheType)")
                        // The source object which contains information like `url`.
                        print(value.source)
                    case .failure(let error):
                        print("error \(error)") // The error happens
                    }
                }
            }
        }
    }
}
