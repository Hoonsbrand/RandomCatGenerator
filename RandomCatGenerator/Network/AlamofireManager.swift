//
//  AlamofireManager.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/01.
//

import Foundation
import Alamofire
import Kingfisher

struct AlamofireManager {
    static let shared = AlamofireManager()
    
    let apiKey = API.CLIENT_ID
    private let baseURL = "https://api.thecatapi.com"
    let searchUrl = "/v1/images/search"
    
    let breedBaseURL = "https://cdn2.thecatapi.com/images/"
    
    private init() {}
    
    // 커스텀 세션을 만들어 디폴트 헤더를 적용
    static var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = [.authorization(API.CLIENT_ID), .accept("application/json")]
        return Alamofire.Session(configuration: configuration)
    }()
    
    func getRandomCat(completion: @escaping(_ result: Data) -> Void) {
        AlamofireManager.sessionManager
            .request(baseURL + searchUrl, method: .get)
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
    
    func getBreedURL(imageId: String, completion: @escaping(URL) -> Void) {
        let urlString = breedBaseURL + "\(imageId).jpg"
        guard let url = URL(string: urlString) else { return }
        
        completion(url)
    }
    
}
