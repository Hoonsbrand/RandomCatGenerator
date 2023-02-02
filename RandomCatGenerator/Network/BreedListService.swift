//
//  BreedListService.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/02.
//

import Foundation

struct BreedListService {
    static let shared = BreedListService()
    
    // breed 데이터 Fetching
    func fetchBreedList(completion: @escaping (BreedList) -> Void) {
        guard let path = Bundle.main.path(forResource: "breeds", ofType: "json") else { return }
        
        guard let jsonString = try? String(contentsOfFile: path) else { return }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let breed = try? decoder.decode(BreedList.self, from: data) {
            completion(breed)
        }
    }
}
