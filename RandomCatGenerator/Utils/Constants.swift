//
//  Constants.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/01.
//

import Foundation

enum API {
    // api key 은닉
    static let CLIENT_ID: String = Bundle.main.THECAT_API_KEY
}

extension Bundle {
    var THECAT_API_KEY: String {
        guard let file = self.path(forResource: "TheCatAPIInfo", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["THECAT_API_KEY"] as? String else {
            fatalError("THECAT_API_KEY error")
        }
        return key
    }
}
