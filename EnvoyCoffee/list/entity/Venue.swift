//
//  Venue.swift
//  EnvoyCoffee
//
//  Created by Kelvin Lee on 1/27/19.
//  Copyright © 2019 Kelvin Lee. All rights reserved.
//
import IGListKit

struct Location {
    var lat: String
    var lng: String
    var formattedAddress: String
    
    init(lat: String, lng: String, address: String) {
        self.lat = lat
        self.lng = lng
        self.formattedAddress = address
    }
}

struct Categories {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

class Venue: Decodable {
    var id: String!
    var name: String!
    var location: Location!
    var categories: Categories!
    var checkins: Int!
    var price: String!
    var rating: Float!
    var photoUrl: String?
    var isOpen: Bool = false
    
    enum VenueKey: String, CodingKey {
        case id = "id"
        case name = "name"
        case location = "location"
        case categories = "categories"
    }
    
    enum VenueLocation: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
        case formattedAddress = "formattedAddress"
    }
    
    enum VenueCategories: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(id: String, name: String, location: Location, categories: Categories, checkins: Int, price: String, rating: Float, isOpen: Bool) {
        self.id = id
        self.name = name
        self.location = location
        self.categories = categories
        self.checkins = checkins
        self.price = price
        self.rating = rating
        self.isOpen = isOpen
    }
    
    required convenience init(from decoder: Decoder) throws {
        let rootValues = try decoder.container(keyedBy: VenueKey.self)
        
        let id: String = try rootValues.decode(String.self, forKey: .id)
        let name: String = try rootValues.decode(String.self, forKey: .name)
        let locationValues = try rootValues.nestedContainer(keyedBy: VenueLocation.self, forKey: .location)
        
        let lat = try locationValues.decode(String.self, forKey: .lat)
        let lng = try locationValues.decode(String.self, forKey: .lng)
        let formattedAddress = try locationValues.decode(String.self, forKey: .formattedAddress)
        
        let location = Location(lat: lat, lng: lng, address: formattedAddress)
        
        let categoriesValues = try rootValues.nestedContainer(keyedBy: VenueCategories.self, forKey: .categories)
        
        let categoryId = try categoriesValues.decode(String.self, forKey: .id)
        let categoryName = try categoriesValues.decode(String.self, forKey: .name)
        
        let categories = Categories(id: categoryId, name: categoryName)
        
        self.init(id: id, name: name, location: location, categories: categories, checkins: 0, price: "", rating: 0.0, isOpen: false)
    }
}

extension Venue: ListDiffable {
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? Venue {
            return name == object.name
        }
        return false
    }
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
}
