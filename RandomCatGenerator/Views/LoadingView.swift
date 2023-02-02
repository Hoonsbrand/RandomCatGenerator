//
//  LoadingView.swift
//  RandomCatGenerator
//
//  Created by hoonsbrand on 2023/02/01.
//

import UIKit
import SnapKit
import Lottie

final class LoadingView: UIView {
    static let shared = LoadingView()
    
    private var loadingWindow: UIWindow?
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    private let loadingView: LottieAnimationView = {
        let view = LottieAnimationView(name: "cat_loading")
        view.loopMode = .loop
        return view
    }()
    
    private init() {
        super.init(frame: .zero)
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.loadingView)
        
        self.contentView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.loadingView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide)
            $0.size.equalTo(300)
        }
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func show() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first(where: { $0.isKeyWindow }) else { return }
        self.loadingWindow = window

        loadingWindow?.addSubview(self)
        self.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
        
        self.loadingView.play()
        UIView.animate(
            withDuration: 0.7,
            animations: { self.contentView.alpha = 1 }
        )
    }
    
    func hide(completion: @escaping () -> () = {}) {
        self.loadingView.stop()
        self.removeFromSuperview()
        completion()
    }
}
