//
//  AlamofireManager.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/01.
//

import Foundation
import Alamofire

struct AlamofireManager {
    static let shared = AlamofireManager()
    
    let apiKey = API.CLIENT_ID
    private let baseURL: String = "https://api.thecatapi.com"
    
    private init() {}
    
    // 커스텀 세션을 만들어 디폴트 헤더를 적용
    static var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = [.authorization(API.CLIENT_ID), .accept("application/json")]
        return Alamofire.Session(configuration: configuration)
    }()
    
    func getRandomCat(completion: @escaping(_ result: Data) -> Void) {
        let url = "/v1/images/search"
        
        AlamofireManager.sessionManager
            .request(baseURL + url, method: .get)
            .validate(statusCode: 200..<300)
            .responseString { response in
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
