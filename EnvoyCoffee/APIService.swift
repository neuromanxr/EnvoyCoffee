//
//  APIService.swift
//  EnvoyCoffee
//
//  Created by Kelvin Lee on 1/27/19.
//  Copyright © 2019 Kelvin Lee. All rights reserved.
//

import Moya

enum APIService {
    case searchVenuesForLocation(params: [String: Any])
    case getPhotoForVenue(id: String, params: [String: Any])
}

extension APIService: TargetType {
    
    var headers: [String : String]? {
        return nil
    }
    
    static let clientId = "ET1S1LUAMDSBJ2R4NG5KB3G0RJ5O5W13BEO4N3WYKB3LENJG"
    static let clientSecret = "XAM11SY2HPWZ0TJYOONA3AULG1VPJP2NHUAQQHDAUEEBKMI1"
    static let baseURLPath = "https://api.foursquare.com"
    
    var baseURL: URL { return URL(string: APIService.baseURLPath)! }
    
    var path: String {
        switch self {
        case .searchVenuesForLocation(_):
            return "/v2/venues/explore"
        case .getPhotoForVenue(let id, _):
            return "/v2/venues/\(id)/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchVenuesForLocation:
            return .get
        case .getPhotoForVenue:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .getPhotoForVenue(_, params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case let .searchVenuesForLocation(params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .searchVenuesForLocation, .getPhotoForVenue:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
