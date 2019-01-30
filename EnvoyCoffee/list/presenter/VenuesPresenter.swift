//
//  PostFeedPresenter.swift
//  archery
//
//  Created by Kelvin Lee on 10/15/18.
//  Copyright © 2018 Kelvin Lee. All rights reserved.
//

import UIKit

class VenuesPresenter: ViewToPresenterVenuesProtocol {
    var view: PresenterToViewVenuesProtocol?
    
    var interactor: PresenterToInteractorVenuesProtocol?
    
    var router: PresenterToRouterVenuesProtocol?
    
    func startFetchVenues(limit: Int?, nextToken: String?) {
        interactor?.fetchVenues(limit: limit, nextToken: nextToken)
    }
    
    func showVenuesDetailController(navigationController: UINavigationController, venue: Venue) {
        router?.pushVenuesDetailController(navigationController: navigationController, venue: venue)
    }
}

extension VenuesPresenter: InteractorToPresenterVenuesProtocol {
    func venueFetchSuccess(response: [Venue]) {
        view?.venues(response: response)
    }
    
    func venueFetchFailed() {
        view?.showError()
    }
}
