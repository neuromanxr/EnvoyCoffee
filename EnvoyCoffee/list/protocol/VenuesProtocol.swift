//
//  PostFeedProtocol.swift
//  archery
//
//  Created by Kelvin Lee on 10/11/18.
//  Copyright © 2018 Kelvin Lee. All rights reserved.
//

import UIKit

protocol ViewToPresenterVenuesProtocol: class {
    var view: PresenterToViewVenuesProtocol? {get set}
    var interactor: PresenterToInteractorVenuesProtocol? {get set}
    var router: PresenterToRouterVenuesProtocol? {get set}
    func startFetchVenues(limit: Int?, nextToken: String?)
    func showVenuesDetailController(navigationController: UINavigationController, venue: Venue)
}

protocol PresenterToViewVenuesProtocol: class {
    func venues(response: [Venue])
    func showError()
}

protocol PresenterToRouterVenuesProtocol: class {
    static func createModule() -> VenuesViewController
    func pushVenuesDetailController(navigationController:UINavigationController, venue: Venue)
}

protocol PresenterToInteractorVenuesProtocol: class {
    var presenter:InteractorToPresenterVenuesProtocol? {get set}
    func fetchVenues(limit: Int?, nextToken: String?)
}

protocol InteractorToPresenterVenuesProtocol: class {
    func venueFetchSuccess(response: [Venue])
    func venueFetchFailed()
}
