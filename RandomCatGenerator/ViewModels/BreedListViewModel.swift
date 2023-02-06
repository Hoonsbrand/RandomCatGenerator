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
    
    var country: String { return breed.origin }
    
    var type: String {
        if breed.natural == 0 {
            return ""
        } else {
            return "natural"
        }
    }
    
    var name: String { return breed.name }
    
    var description: String { return breed.description }
    
    var temperament: String { return breed.temperament }
    
    var characteristics = ["애정도", "적응성", "아동 친화력",
                           "개 친화력", "활동 능력", "청결도",
                           "건강 문제", "지능", "털날림"]
    
    lazy var characterLevelArray = [affectionLevel, adaptability, childFriendly,
                                    dogFriendly, energyLevel, grooming, healthIssues,
                                    intelligence, sheddingLevel]
    
    var affectionLevel: Int { return breed.affectionLevel }
    
    var adaptability: Int { return breed.adaptability }
    
    var childFriendly: Int { return breed.childFriendly }
    
    var dogFriendly: Int { return breed.dogFriendly }
    
    var energyLevel: Int { return breed.energyLevel }
    
    var grooming: Int { return breed.grooming }
    
    var healthIssues: Int { return breed.healthIssues }
    
    var intelligence: Int { return breed.intelligence }
    
    var sheddingLevel: Int { return breed.sheddingLevel }
    
//    var socialNeeds: Int { return breed.socialNeeds }
    
//    var strangerFriendly: Int { return breed.strangerFriendly }
    
//    var vocalisation: Int { return breed.vocalisation }
    
    init(breed: Breed) {
        self.breed = breed
    }
}
