//
//  VenuesSectionController.swift
//  EnvoyCoffee
//
//  Created by Kelvin Lee on 10/13/18.
//  Copyright © 2018 Kelvin Lee. All rights reserved.
//

import UIKit
import IGListKit
import Kingfisher

class VenuesSectionController: ListSectionController {
    
    var venue: Venue!
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard var width = self.collectionContext?.containerSize.width else {
            return CGSize(width: 0, height: 100)
        }
//        width = floor(width / 2)
        return CGSize(width: width, height: 300.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = self.collectionContext!.dequeueReusableCell(withNibName: VenuesCell.reuseIdentifier, bundle: Bundle.main, for: self, at: index) as! VenuesCell
        cell.setup(venue: venue)
        
        return cell
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func didUpdate(to object: Any) {
        self.venue = object as? Venue
    }
    
    override func didSelectItem(at index: Int) {
        guard let venuesViewController = self.viewController as? VenuesViewController else {
            return
        }
        venuesViewController.presenter?.showVenuesDetailController(navigationController: venuesViewController.navigationController!, venue: self.venue)
    }
}
