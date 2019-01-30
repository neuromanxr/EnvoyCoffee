//
//  PostFeedInteractor.swift
//  archery
//
//  Created by Kelvin Lee on 10/15/18.
//  Copyright © 2018 Kelvin Lee. All rights reserved.
//

import UIKit
import PromiseKit

class VenuesInteractor: PresenterToInteractorVenuesProtocol {
    var presenter: InteractorToPresenterVenuesProtocol?
    
    func fetchVenues(limit: Int?, nextToken: String?) {
        var params = [String: Any]()
        guard let limit = limit else {
            return
        }
        firstly {
            LocationManager.shared.getLatLongFromAddress()
            }.get { coordinate in
                debugPrint("coordinate:\(coordinate)")
                params = ["client_id": APIService.clientId, "client_secret": APIService.clientSecret, "ll": coordinate, "query": "coffee", "v": "20180323", "limit": limit]
            }.then { _ in
                SearchManager.shared.searchVenuesForLocation(params: params)
            }.then { venues in
                SearchManager.shared.setPhotoUrls(venues: venues)
            }.get { venues in
                self.presenter?.venueFetchSuccess(response: venues)
            }.ensure {
                
            }.catch { error in
                debugPrint("searchVenuesForLocation error:\(error)")
                self.presenter?.venueFetchFailed()
        }
    }
}
