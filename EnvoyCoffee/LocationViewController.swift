//
//  LocationViewController.swift
//  EnvoyCoffee
//
//  Created by Kelvin Lee on 1/25/19.
//  Copyright © 2019 Kelvin Lee. All rights reserved.
//

import UIKit
import SwiftMessages
import MapKit

enum LocationTypes: String {
    case envoy = "Coffee near Envoy"
    case mine = "Coffee near me"
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier, for: indexPath) as! LocationCell
        let location = locations[indexPath.row]
        cell.titleLabel.text = location.rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        let venuesViewController = VenueRouter.createModule()
        venuesViewController.location = location
        let navigationController = UINavigationController(rootViewController: venuesViewController)
        
        let segue = SwiftMessagesSegue(identifier: nil, source: self, destination: navigationController)
        segue.configure(layout: .centered)
        segue.perform()
    }
}

class LocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let locations = [LocationTypes.envoy, LocationTypes.mine]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }


}

