//
//  LocationManager.swift
//  EnvoyCoffee
//
//  Created by Kelvin Lee on 1/28/19.
//  Copyright © 2019 Kelvin Lee. All rights reserved.
//

import PromiseKit
import MapKit

class LocationManager {
    static let shared = LocationManager()
    
    func getLatLongFromAddress() -> Promise <(String)> {
        return Promise { seal in
            let geocoder = CLGeocoder()
            let dic = "410 Townsend St, San Francisco, CA"
            geocoder.geocodeAddressString(dic) { (placemark, error) in
                if let error = error {
                    print(error)
                    seal.reject(error)
                }
                guard let placemark = placemark?.first, let lat = placemark.location?.coordinate.latitude, let long = placemark.location?.coordinate.longitude else {
                    seal.fulfill("Error")
                    return
                }
                let coordinateString = String(lat) + "," +  String(long)
                
                seal.resolve(coordinateString, error)
            }
        }
    }
}
