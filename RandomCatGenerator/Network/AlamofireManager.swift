//
//  AlamofireManager.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/01.
//

import Foundation
import Alamofire

final class AlamofireManager {
    static let shared = AlamofireManager()
    
    let apiKey = API.CLIENT_ID
    private let baseURL: String = "https://api.thecatapi.com"
    
    private init() {}
    
    static var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [:]
        configuration.httpAdditionalHeaders?["Accept"] = "application/json"
        return Alamofire.Session(configuration: configuration)
    }()
    
    func getRandomCat(parameters: Parameters, completion: @escaping(_ result: Data) -> Void) {
        let url = "/v1/images/search"
        let parameters = parameters
  
        AlamofireManager.sessionManager.request(baseURL + url, method: .get, parameters: parameters).responseString { response in
            switch response.result {
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(error)
                print(response.data!)
                break
            }
        }
    }
    
}
