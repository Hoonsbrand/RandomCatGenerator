//
//  AlamofireManager.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/01.
//

import Foundation
import Alamofire
import SwiftyJSON

final class AlamofireManager {
    static let shared = AlamofireManager()
    
    /// ------------------- 사진 가져오는 Base URL -------------------
    private let apiKey = API.CLIENT_ID
    private let baseURL = "https://api.thecatapi.com"
    private let searchUrl = "/v1/images/search"
    
    private let breedBaseURL = "https://cdn2.thecatapi.com/images/"
    
    /// ------------------- 품종별 사진 가져오는 파라미터 -------------------
    private var breedParam: [String: Any] = ["limit": 7] // 사진개수 고정, 품종은 유동적이므로 메서드에서 추가
    
    private init() {}
    
    // 커스텀 세션을 만들어 디폴트 헤더를 적용
    static var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = ["x-api-key" : "live_VVrwe9YTXBomgBRyvsH0gnqGqIf3Tk646CYcX7pnQ7ThVwrnfBtgl6dGAi6ygRPb",
                                 "Accept": "apllication/json"]
        return Alamofire.Session(configuration: configuration)
    }()
    
    // 랜덤 고양이 사진을 가져오는 메서드, 메인 뷰에서 호출
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
    
    // 선택한 품종의 사진을 가져오는 메서드, viewModel에서 호출
    func getBreedImageURL(breedId: String, completion: @escaping(_ result: [URL]) -> Void) {
        var urlArray = [URL]()
        breedParam["breed_ids"] = breedId

        AlamofireManager.sessionManager
            .request(baseURL + searchUrl, method: .get, parameters: breedParam)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        let responseJson = JSON(asJSON)
                        print(responseJson)
                        for (_, subJson): (String, JSON) in responseJson {
                            guard let urlString = subJson["url"].string else { continue }
                            guard let url = URL(string: urlString) else { continue }
                            /// https://cocoapods.org/pods/SwiftGoogleTranslate
                            /// 구글 번역 사용해서 번역해보기..?
                            urlArray.append(url)
                        }
                        completion(urlArray)
                    } catch {
                        print("Error while decoding response: \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func getBreedURL(imageId: String, completion: @escaping(URL) -> Void) {
        let urlString = breedBaseURL + "\(imageId).jpg"
        guard let url = URL(string: urlString) else { return }
        
        completion(url)
    }
    
}
