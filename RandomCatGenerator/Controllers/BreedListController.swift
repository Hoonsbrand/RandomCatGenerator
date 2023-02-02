//
//  BreedListController.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/02.
//

import UIKit
import SnapKit
import DropDown

final class BreedListController: UIViewController {
    
    // MARK: - Properties
    
    // 품종 선택 버튼
    private lazy var changeBreedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Abyssinian", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        
        return button
    }()
    
    // 고양이 사진 ImageView
    private let catImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .brown
        iv.snp.makeConstraints { $0.height.equalTo(300) }
        return iv
    }()
    
    // 고양이 출신 나라 label
    private lazy var originLabel: UILabel = {
        return makeLabel(text: "이집트")
    }()
    
    // 품종 타입 label
    private lazy var breedTypeLabel: UILabel = {
        return makeLabel(text: "Natural")
    }()
    
    // 품종 이름 label
    private lazy var breedNameLabel: UILabel = {
        return makeLabel(text: "Abyssinian", size: 20)
    }()
    
    // 품종 설명 label
    private lazy var descriptionLabel: UILabel = {
        return makeLabel(text: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.\n")
    }()
    
    // 특성 키워드 label
    private lazy var temperamentLabel: UILabel = {
        return makeLabel(text: "Active, Energetic, Independent, Intelligent, Gentle")
    }()
    
    // 더미 View
    private let dummyView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
  
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9710575374, blue: 0.7176470588, alpha: 1)
        
        view.addSubview(changeBreedButton)
        changeBreedButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(catImageView)
        catImageView.snp.makeConstraints {
            $0.top.equalTo(changeBreedButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        let originStack = UIStackView(arrangedSubviews: [originLabel, breedTypeLabel])
        originStack.axis = .horizontal
        view.addSubview(originStack)
        originStack.snp.makeConstraints {
            $0.top.equalTo(catImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(5)
        }
        
        let descriptionStack = UIStackView(arrangedSubviews: [breedNameLabel, descriptionLabel, temperamentLabel])
        descriptionStack.axis = .vertical
        descriptionStack.spacing = 10
        view.addSubview(descriptionStack)
        descriptionStack.snp.makeConstraints {
            $0.top.equalTo(originStack.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        view.addSubview(dummyView)
        dummyView.snp.makeConstraints {
            $0.top.equalTo(descriptionStack.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Helpers
    
    private func makeLabel(text: String, size: CGFloat = 15) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size)
        label.text = text
        label.numberOfLines = 0
        return label
    }
    
    // MARK: - Selectors
    
    @objc func showDropDown() {
        let dropDown = DropDown()
        for i in 0..<15 {
            dropDown.dataSource.append("\(i)")
        }
        dropDown.show()
    }
}
