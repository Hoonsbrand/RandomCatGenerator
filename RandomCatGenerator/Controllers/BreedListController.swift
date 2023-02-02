//
//  BreedListController.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/02.
//

import UIKit
import SnapKit
import DropDown
import Kingfisher

final class BreedListController: UIViewController {
    
    // MARK: - Properties
    
    private let dropDown = DropDown()
    
    private var breedList: BreedList?
    
    private var viewModel: BreedListViewModel? {
        didSet {
            setBreedInformation()
        }
    }
    
    // 품종 선택 버튼
    private lazy var changeBreedButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        return button
    }()
    
    private let changeBreedView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var changeBreedTextField: UITextField = {
        let tf = UITextField()
        tf.text = "냥이를 선택해주세요!"
        tf.font = UIFont.boldSystemFont(ofSize: 15)
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    private var dropDownIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrowtriangle.down.fill")
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // 고양이 사진 ImageView
    private let catImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // 고양이 출신 나라 label
    private lazy var originLabel: UILabel = {
        return makeLabel()
    }()
    
    // 품종 타입 label
    private lazy var breedTypeLabel: UILabel = {
        return makeLabel()
    }()
    
    // 품종 이름 label
    private lazy var breedNameLabel: UILabel = {
        return makeLabel(size: 20)
    }()
    
    // 품종 설명 label
    private lazy var descriptionLabel: UILabel = {
        return makeLabel()
    }()
    
    // 특성 키워드 label
    private lazy var temperamentLabel: UILabel = {
        return makeLabel()
    }()
    
    // 더미 View
    private let dummyView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.7912161358, blue: 0.573695015, alpha: 1)
        return view
    }()
  
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchBreedList()
        configureDropDown()
    }
    
    // MARK: - Helpers
    
    // 반복되는 label 만드는 작업을 도와주는 메서드
    private func makeLabel(size: CGFloat = 15) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size)
        label.numberOfLines = 0
        return label
    }
    
    private func setBreedInformation() {
        guard let viewModel = viewModel else { return }
        viewModel.getBreedURL { [weak self] url in
            guard let self = self else { return }
            print(url)
            self.catImageView.kf.setImage(with: url)
        }
        originLabel.text = viewModel.country
        breedTypeLabel.text = viewModel.type
        breedNameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        temperamentLabel.text = viewModel.temperament
    }
    
    // 전체 UI 구성
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9710575374, blue: 0.7176470588, alpha: 1)
        setChangeBreedButton()
        setCatImageView()
        setStackView()
    }
    
    // 품종변경 버튼 세팅
    private func setChangeBreedButton() {
        
        view.addSubview(changeBreedView)
        
        let stack = UIStackView(arrangedSubviews: [changeBreedTextField, dropDownIcon])
        stack.axis = .horizontal
        stack.spacing = 10
        changeBreedView.addSubview(stack)
        
        changeBreedView.addSubview(changeBreedButton)

        changeBreedView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(240)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        changeBreedButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // 품종사진 View 세팅
    private func setCatImageView() {
        view.addSubview(catImageView)
        catImageView.snp.makeConstraints {
            $0.height.equalTo(250)
            $0.top.equalTo(changeBreedButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 품종 나라부터 특성까지의 StackView
    private func setStackView() {
        // 품종 나라, 품종 타입 StackView
        let originStack = UIStackView(arrangedSubviews: [originLabel, breedTypeLabel])
        originStack.axis = .horizontal
        view.addSubview(originStack)
        originStack.snp.makeConstraints {
            $0.top.equalTo(catImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(5)
        }
        
        // 품종이름, 설명, 키워드 StackView
        let descriptionStack = UIStackView(arrangedSubviews: [breedNameLabel, descriptionLabel, temperamentLabel])
        descriptionStack.axis = .vertical
        descriptionStack.spacing = 10
        view.addSubview(descriptionStack)
        descriptionStack.snp.makeConstraints {
            $0.top.equalTo(originStack.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        // DummyView
        view.addSubview(dummyView)
        dummyView.snp.makeConstraints {
            $0.top.equalTo(descriptionStack.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - fetchBreedList

extension BreedListController {
    // 품종 리스트를 얻어옴. viewDidLoad에서 호출됨.
    private func fetchBreedList() {
        BreedListService.shared.fetchBreedList { breedList in
            self.breedList = breedList
            
            // 가져온 품종 리스트를 멤버 변수에 할당
            for i in 0..<breedList.count {
                self.dropDown.dataSource.append(breedList[i].name)
            }
        }
    }
}

// MARK: - ConfigureDropDown

extension BreedListController {
    // 버튼을 누르면 보여지는 DropDown
    @objc func showDropDown() {
        dropDown.show()
        dropDownIcon.image = UIImage(systemName: "arrowtriangle.up.fill")
        print(dropDown.isOpaque)
    }
    
    private func configureDropDown() {
        // DropDown을 버튼 하단에 위치하게 함
        dropDown.anchorView = changeBreedButton
        dropDown.bottomOffset = CGPoint(x: 0, y: changeBreedButton.bounds.height + 40)
        
        dropDown.textColor = .black // 아이템 텍스트 색상
        dropDown.selectedTextColor = .brown // 선택된 아이템 텍스트 색상
        dropDown.backgroundColor = .white // 아이템 팝업 배경 색상
        dropDown.selectionBackgroundColor = .lightGray // 선택한 아이템 배경 색상
        dropDown.setupCornerRadius(8)
        dropDown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        
        // 품종 선택 시
        dropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            self.changeBreedTextField.text = item
            self.dropDownIcon.image = UIImage(systemName: "arrowtriangle.down.fill")
            
            let breed = self.breedList?.filter { $0.name == item }
            guard let breed = breed?.first else { return }
            self.viewModel = BreedListViewModel(breed: breed)
        }
        
        // 취소 시
        dropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.dropDownIcon.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
    }
}

