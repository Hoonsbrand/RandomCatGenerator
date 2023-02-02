//
//  BreedListViewModel.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/02.
//

import UIKit

struct BreedListViewModel {
    private let breed: Breed
    
    func getBreedURL(completion: @escaping(URL) -> Void) {
        guard let imageId = breed.referenceImageID else { return }
        AlamofireManager.shared.getBreedURL(imageId: imageId) { url in
            completion(url)
        }
    }
    
    var country: String {
        return breed.origin
    }
    
    var type: String {
        if breed.natural == 0 {
            return ""
        } else {
            return "natural"
        }
    }
    
    var name: String {
        return breed.name
    }
    
    var description: String {
        return breed.description
    }
    
    var temperament: String {
        return breed.temperament
    }
    
    init(breed: Breed) {
        self.breed = breed
    }
}
