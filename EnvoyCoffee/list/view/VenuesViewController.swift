//
//  VenuesViewController.swift
//  EnvoyCoffee
//
//  Created by Kelvin Lee on 10/11/18.
//  Copyright © 2018 Kelvin Lee. All rights reserved.
//

import UIKit
import IGListKit
import PromiseKit
import RxSwift
import RxCocoa
import SwiftMessages
import SkeletonView

class VenuesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: ViewToPresenterVenuesProtocol?
    
    var location: LocationTypes = .envoy
    var venues = [Venue]()
    var nextToken: String?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action: #selector(VenuesViewController.handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 4)
    }()
    
    let disposeBag = DisposeBag()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 110)
        
        self.navigationItem.title = "Coffee"
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(VenuesViewController.close))
        self.navigationItem.rightBarButtonItem = closeButton
        
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.barStyle = .blackTranslucent
        searchController.searchBar.tintColor = .orange
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        
        searchController.searchBar.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ !$0.isEmpty })
            .subscribe(onNext: { [unowned self] query in
                debugPrint("searching query...:\(query.lowercased())")
                
                self.venues = self.venues.filter { $0.name.contains(query) }
                self.adapter.reloadData { (complete) in
                    
                }
                
            }).disposed(by: self.disposeBag)
        
        let layout = ListCollectionViewLayout(stickyHeaders: true, scrollDirection: .vertical, topContentInset: 2.0, stretchToEdge: true)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        self.adapter.delegate = self
        
        self.collectionView.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch location {
        case .envoy:
            debugPrint("envoy")
            presenter?.startFetchVenues(limit: 15, nextToken: nil)
            break
        case .mine:
            debugPrint("mine")
            break
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func handleRefresh() {
        debugPrint("Refresh")
        
        self.venues.removeAll()
        presenter?.startFetchVenues(limit: 15, nextToken: nil)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension VenuesViewController: PresenterToViewVenuesProtocol {
    func venues(response: [Venue]) {
        debugPrint("Response venue count:\(response.first?.photoUrl)")
        
        self.venues = response
        self.adapter.reloadData { (complete) in
            
        }
        self.refreshControl.endRefreshing()
    }
    
    func showError() {
        debugPrint("Fetch error")
    }
}

extension VenuesViewController: IGListAdapterDelegate {
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        debugPrint("willDisplay index:\(index)")
        
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
}

extension VenuesViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.venues as! [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        default:
            return VenuesSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let customView = UIView()
//        customView.loadingIndicator.startAnimating()
//        customView.isSkeletonable = true
//        customView.showAnimatedGradientSkeleton()
        
        return customView
    }
}

extension VenuesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("selectedScopeButtonIndexDidChange")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("search cancelled")
        self.handleRefresh()
    }
}
