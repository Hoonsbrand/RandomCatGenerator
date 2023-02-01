//
//  ViewController.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/01.
//

import UIKit
import SnapKit
import Alamofire

final class RandomCatViewController: UIViewController {

    // MARK: - Properties
    
    // 고양이 사진을 보여주는 ImageView
    private let catImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        return iv
    }()
    
    // 새로운 고양이 이미지를 받아오기 위한 버튼
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("고양이 소환!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(getRandomCat), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setRefreshButton()
        setCatImageView()
        getRandomCat()
    }
    
    // MARK: - Helpers
    
    private func setCatImageView() {
        view.addSubview(catImageView)
        catImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(refreshButton.snp.top)
        }
    }
    
    private func setRefreshButton() {
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - API

extension RandomCatViewController {
    
    // 고양이 사진 url을 받아오는 메서드
    @objc func getRandomCat() {
        let parameters: Parameters = ["x-api-key" : AlamofireManager.shared.apiKey]
        
        AlamofireManager.shared.getRandomCat(parameters: parameters) { result in
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
            }
        }
    }
}

