//
//  ViewController.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/01.
//

import UIKit
import SnapKit
import Alamofire
import Lottie

final class RandomCatViewController: UIViewController {

    // MARK: - Properties
    
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
    
    // 런치화면에서 보여줄 Lottie
    private let launchAnimationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "cat_launch")
        return lottieAnimationView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9710575374, blue: 0.7176470588, alpha: 1)
        navigationItem.title = "고양이 생성기"
        let breedButton = UIBarButtonItem(image: UIImage(systemName: "pawprint.circle"), style: .plain, target: self, action: #selector(goToBreedController))
        self.navigationItem.rightBarButtonItem = breedButton
        
        view.addSubview(launchAnimationView)
        launchAnimationView.frame = view.bounds
        launchAnimationView.center = view.center
        launchAnimationView.alpha = 1
        
        launchAnimationView.play { _ in
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
}

// MARK: - API

extension RandomCatViewController {
    
    // 고양이 사진 url을 받아오는 메서드
    @objc func getRandomCat() {
        LoadingView.shared.show()
        
        AlamofireManager.shared.getRandomCat() { result in
            do {
                let res = try JSONDecoder().decode([Cat].self, from: result)
                print("DEBUG: 고양이 사진 url : \(res[0].url ?? "url 없음")")
                self.loadCatImage(res[0].url)
            } catch {
                print("DEBUG: \(error)")
            }
        }
    }
    
    // 고양이 사진을 ImageView에 넣는 메서드
    private func loadCatImage(_ url: String?) {
        let downloadQueue = DispatchQueue(__label: url, attr: nil)
        downloadQueue.async() {
            let data = NSData(contentsOf: NSURL(string: url!)! as URL)
            var image: UIImage?
            
            guard data != nil else { return }
            image = UIImage(data: data! as Data)
            
            DispatchQueue.main.async {
                self.catImageView.image = image
                LoadingView.shared.hide()
            }
        }
    }
}

// MARK: - Push View

extension RandomCatViewController {
    @objc func goToBreedController() {
        let controller = BreedListController()
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
