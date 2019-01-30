//
//  SearchManager.swift
//  EnvoyCoffee
//
//  Created by Kelvin Lee on 1/27/19.
//  Copyright © 2019 Kelvin Lee. All rights reserved.
//
import Moya
import PromiseKit
import SwiftyJSON

class SearchManager {
    static let shared = SearchManager()
    
    func setPhotoUrls(venues: [Venue]) -> Promise<[Venue]> {
        return Promise { seal in
            let group = DispatchGroup()
            for (_,venue) in venues.enumerated() {
                debugPrint("response venue:\(venue.name)")
                group.enter()
                SearchManager.shared.getPhotoUrlForVenue(id: venue.id).get { url in
                    debugPrint("getPhotoUrlForVenue:\(url)")
                    venue.photoUrl = url
                    group.leave()
                    }.catch { error in
                        debugPrint("getPhotoUrlForVenue error:\(error)")
                        group.leave()
                }
            }
            group.notify(queue: .main, execute: {
                debugPrint("group complete")
                seal.fulfill(venues)
            })
        }
    }
    
    func getPhotoUrlForVenue(id: String) -> Promise<String> {
        return Promise { seal in
            let params: [String: Any] = ["client_id": APIService.clientId, "client_secret": APIService.clientSecret, "v": "20180323",  "limit": 1]
            let provider = MoyaProvider<APIService>()
            provider.request(.getPhotoForVenue(id: id, params: params), completion: { (result) in
                debugPrint("result:\(result.value?.request)")
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        let photosJson = JSON(filteredResponse.data)
                        let photo = photosJson["response"]["photos"]["items"][0]
                        let prefix = photo["prefix"].stringValue
                        let suffix = photo["suffix"].stringValue
                        let url = "\(prefix)width300\(suffix)"
                        debugPrint("url:\(url)")
                        seal.fulfill(url)
                        
                    }
                    catch let error {
                        debugPrint("error:\(error.localizedDescription)")
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                    break
                }
            })
        }
    }
    
    func searchVenuesForLocation(params: [String: Any]) -> Promise<[Venue]> {
        return Promise { seal in
            let provider = MoyaProvider<APIService>()
            provider.request(.searchVenuesForLocation(params: params), completion: { (result) in
                debugPrint("response:\(result.result)")
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        let venuesJson = JSON(filteredResponse.data)
                        let venuesArray = venuesJson["response"]["groups"][0]["items"].arrayValue
                        var venues = [Venue]()
                        for venue in venuesArray {
                            let venueRoot = venue["venue"]
                            let id = venueRoot["id"].stringValue
                            let name = venueRoot["name"].stringValue
                            let locationJson = venueRoot["location"]
                            let lat = String(locationJson["lat"].floatValue)
                            let long = String(locationJson["lng"].floatValue)
                            let address = locationJson["formattedAddress"].arrayValue.map { $0.stringValue }.first!
                            let location = Location(lat: lat, lng: long, address: address)
                            let categoriesJson = venueRoot["categories"][0]
                            let categoryId = categoriesJson["id"].stringValue
                            let categoryName = categoriesJson["name"].stringValue
                            let category = Categories(id: categoryId, name: categoryName)
                            let checkins = venueRoot["stats"]["checkinsCount"].intValue
                            let price = venueRoot["price"]["message"].stringValue
                            let rating = venueRoot["rating"].floatValue
                            let isOpen = venueRoot["hours"]["isOpen"].boolValue
                            let venue = Venue(id: id, name: name, location: location, categories: category, checkins: checkins, price: price, rating: rating, isOpen: isOpen)
                            venues.append(venue)
                        }
                        debugPrint("venuesJson:\(venues)")
                        seal.fulfill(venues)
                        
                    }
                    catch let error {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                    break
                }
            })
        }
    }
}
