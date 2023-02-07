//
//  BreedListViewModel.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/02.
//

import UIKit
import Kingfisher
import ImageSlideshow

struct BreedListViewModel {
    private let breed: Breed
    
    func getBreedImageURL(completion: @escaping([InputSource]) -> Void) {
        var slider = [InputSource]()
        
        AlamofireManager.shared.getBreedImageURL(breedId: breedId) { urlArray in
            for i in 0..<urlArray.count {
                slider.append(KingfisherSource(url: urlArray[i]))
            }
            completion(slider)
        }
    }
    
    var breedId: String { return breed.id }
    
    var country: String { return breed.origin }
    
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
    
    var weight: String { return "평균 몸무게: \(breed.weight.metric)kg" }
    
    var lifeSpan: String { return "평균 수명: \(breed.lifeSpan)년" }
    
    init(breed: Breed) {
        self.breed = breed
    }
}
