//
//  PostFeedRouter.swift
//  archery
//
//  Created by Kelvin Lee on 10/15/18.
//  Copyright © 2018 Kelvin Lee. All rights reserved.
//

import UIKit
import SwiftMessages

class VenueRouter: PresenterToRouterVenuesProtocol {
    static func createModule() -> VenuesViewController {
        let view = mainstoryboard.instantiateViewController(withIdentifier: "VenuesViewController") as! VenuesViewController
        
        let presenter: ViewToPresenterVenuesProtocol & InteractorToPresenterVenuesProtocol = VenuesPresenter()
        let interactor: PresenterToInteractorVenuesProtocol = VenuesInteractor()
        let router:PresenterToRouterVenuesProtocol = VenueRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func pushVenuesDetailController(navigationController: UINavigationController, venue: Venue) {
//        let postDetailPageViewController = PostDetailRouter.createModule()
//
//        let presentationNavigationController = UINavigationController(rootViewController: postDetailPageViewController)
//
//        let postFeed = navigationController.viewControllers.first as! PostFeedViewController
//        let segue = SwiftMessagesSegue(identifier: nil, source: postFeed, destination: presentationNavigationController)
//        segue.configure(layout: .centered)
//        segue.perform()
        
    }
    

}
