//
//  ViewController.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/01.
//

import UIKit
import SnapKit
import Lottie
import Kingfisher

final class RandomCatViewController: UIViewController {

    // MARK: - Properties
    
    private var breedId = "" {
        didSet {
            navigationItem.leftBarButtonItem = backToRandomPhotoButton
            navigationItem.leftBarButtonItem?.isHidden = false
        }
    }
    
    // 런치화면에서 보여줄 Lottie
    private let launchAnimationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "cat_launch")
        return lottieAnimationView
    }()
    
    // 고양이 사진을 보여주는 ImageView
    private let catImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        
        // 이미지 그림자 설정
        iv.layer.shadowOffset = CGSize(width: 5, height: 5)
        iv.layer.shadowOpacity = 0.7
        iv.layer.shadowRadius = 5
        iv.layer.shadowColor = UIColor.gray.cgColor
        return iv
    }()
    
    // 새로운 고양이 이미지를 받아오기 위한 버튼
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("고양이 소환!🐱", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(getRandomCat), for: .touchUpInside)
        return button
    }()
    
    lazy var backToRandomPhotoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                     style: .plain, target: self,
                                     action: #selector(backToRandomPhoto))
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9710575374, blue: 0.7176470588, alpha: 1)
        navigationItem.title = "랜덤 고양이 생성기"
        let breedButton = UIBarButtonItem(image: UIImage(systemName: "pawprint.circle"), style: .plain, target: self, action: #selector(goToBreedController))
        self.navigationItem.rightBarButtonItem = breedButton
        
        view.addSubview(launchAnimationView)
        launchAnimationView.frame = view.bounds
        launchAnimationView.center = view.center
        launchAnimationView.alpha = 1
        
        launchAnimationView.play { [weak self] _ in
            guard let self = self else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.launchAnimationView.alpha = 0
            }, completion: { _ in
                self.launchAnimationView.isHidden = true
                self.launchAnimationView.removeFromSuperview()
                self.setAttribute()
            })
        }
    }

    private func setAttribute() {
        setRefreshButton()
        setCatImageView()
        getRandomCat()
    }
    
    private func setCatImageView() {
        view.addSubview(catImageView)
        catImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(refreshButton.snp.top)
        }
    }
    
    private func setRefreshButton() {
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Selectors
    
    @objc func backToRandomPhoto() {
        breedId = ""
        navigationItem.leftBarButtonItem?.isHidden = true
        navigationItem.title = "랜덤 고양이 생성기"
        getRandomCat()
    }
}

// MARK: - API

extension RandomCatViewController {
    
    // 고양이 사진 url을 받아오는 메서드
    @objc func getRandomCat() {
        LoadingView.shared.show()
        
        AlamofireManager.shared.getRandomCat(breedId: breedId) { [weak self] result in
            guard let self = self else { return }
            
            do {
                let res = try JSONDecoder().decode([Cat].self, from: result)
                guard let url = res[0].url else { return }
                print("DEBUG: 고양이 사진 url : \(url)")
                self.loadCatImage(url)
            } catch {
                print("DEBUG: \(error)")
            }
        }
    }
    
    // 고양이 사진을 ImageView에 넣는 메서드
    private func loadCatImage(_ urlString: String) {
        let downloadQueue = DispatchQueue(__label: urlString, attr: nil)
        downloadQueue.async() { [weak self] in
            guard let self = self else { return }
            
            let url = URL(string: urlString)
            DispatchQueue.main.async {
                self.catImageView.kf.setImage(with: url) { _ in
                    LoadingView.shared.hide()
                }
            }
        }
    }
}

// MARK: - Push View

extension RandomCatViewController {
    @objc func goToBreedController() {
        let controller = BreedListController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SendBreedIdDelegate

extension RandomCatViewController: SendBreedIdDelegate {
    func recieveBreedId(breedname: String, breedId: String) {
        self.breedId = breedId
        navigationItem.title = breedname
        getRandomCat()
    }
}
