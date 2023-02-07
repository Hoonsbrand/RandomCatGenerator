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
import Charts
import ImageSlideshow

final class BreedListController: UIViewController {
    
    // MARK: - Properties
    
    // DropDown
    private let dropDown = DropDown()
    
    // Breedlist
    private var breedList: BreedList?
    
    // BreedListViewModel
    private var viewModel: BreedListViewModel? {
        didSet {
            setBreedInformation()
        }
    }
    
    /// ------------------- 스크롤뷰와 내의 컨텐츠 -------------------
    // 스크롤 뷰
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    // 스크롤 뷰 내의 컨텐츠를 담는 StackView
    private let scrollViewContainer: UIStackView = {
        let sv = UIStackView()
        return sv
    }()
    
    /// ------------------- 최상단 품종선택버튼 -------------------
    // 품종 선택 버튼
    private lazy var changeBreedButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        return button
    }()
    
    // 품종 변경 View
    private let changeBreedView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    // 품종 변경 버튼
    private var changeBreedTextField: UITextField = {
        let tf = UITextField()
        tf.text = "냥이를 선택해주세요!"
        tf.font = UIFont.boldSystemFont(ofSize: 15)
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    // 드랍다운 아이콘
    private var dropDownIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrowtriangle.down.fill")
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    /// ------------------- 고양이 사진 -------------------
    // 고양이 사진 ImageSlideshow
    private lazy var catImageSlider: ImageSlideshow = {
        let slider = ImageSlideshow()
        slider.contentScaleMode = .scaleAspectFill
        slider.zoomEnabled = true
        slider.activityIndicator = DefaultActivityIndicator(style: .large, color: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didImageTapped))
        slider.addGestureRecognizer(gestureRecognizer)
        slider.isUserInteractionEnabled = true
        return slider
    }()
    
    /// ------------------- 출신나라, 품종이름, 설명, 특성 키워드 -------------------
    // 출신나라, 품종이름, 설명, 특성 키워드를 담는 StackView
    private let descriptionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    // 고양이 출신나라 label
    private lazy var originLabel: UILabel = { return makeLabel() }()
    
    // 품종 이름 label
    private lazy var breedNameLabel: UILabel = { return makeLabel(size: 20) }()
    
    // 품종 설명 label
    private lazy var descriptionLabel: UILabel = { return makeLabel() }()
    
    // 평균 몸무게
    private lazy var averageWeightLabel: UILabel = { return makeLabel(size: 12) }()
    
    // 평균 수명
    private lazy var lifeSpanLabel: UILabel = { return makeLabel(size: 12) }()
    
    // 특성 키워드 label
    private lazy var temperamentLabel: UILabel = { return makeLabel(isTemperament: true) }()
    
    /// ------------------- 차트 -------------------
    // 차트 뷰
    private let radarChartView: RadarChartView = {
        let rv = RadarChartView()
        rv.animate(yAxisDuration: 2.0)
        rv.yAxis.enabled = false
        rv.noDataText = "냥이를 선택해주세요!"
        rv.legend.enabled = false
        rv.highlightPerTapEnabled = false
        rv.xAxis.axisMaximum = 5
        rv.xAxis.axisMinimum = 1
        rv.rotationEnabled = false
        return rv
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
    private func makeLabel(size: CGFloat = 15, isTemperament: Bool = false) -> UILabel {
        let label = UILabel()
        
        if !isTemperament {
            label.font = UIFont.systemFont(ofSize: size)
        } else {
            label.font = UIFont.italicSystemFont(ofSize: 12)
            label.textColor = UIColor.systemGray
        }
        
        label.numberOfLines = 0
        return label
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
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(changeBreedView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.snp.makeConstraints {
            $0.top.width.equalToSuperview()
        }
    }
    
    // 품종사진 View 세팅
    private func setCatImageView() {
        // catImageView
        scrollViewContainer.addSubview(catImageSlider)
        catImageSlider.snp.makeConstraints {
            $0.height.equalTo(250)
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
    // 출시나라부터 차트까지의 StackView
    private func setStackView() {
        // 출신나라, 품종이름, 설명, 키워드 StackView
        let _ = [originLabel, breedNameLabel, descriptionLabel,
                 averageWeightLabel, lifeSpanLabel, temperamentLabel].map { descriptionStackView.addArrangedSubview($0) }
        
        scrollViewContainer.addSubview(descriptionStackView)
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(catImageSlider.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        // radarChartView
        scrollViewContainer.addSubview(radarChartView)
        radarChartView.snp.makeConstraints {
            $0.top.equalTo(descriptionStackView.snp.bottom).offset(10)
            $0.width.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
// MARK: - Selectors
    
    @objc func didImageTapped() {
        print("tapped")
        catImageSlider.presentFullScreenController(from: self)
    }
}

// MARK: - 품종 데이터 관련: fetchBreedList & setBreedInformation

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
    
    // viewModel 데이터를 각 UI에 할당
    private func setBreedInformation() {
        guard var viewModel = viewModel else { return }
        
        viewModel.getBreedImageURL { [weak self] images in
            guard let self = self else { return }
            self.catImageSlider.setImageInputs(images)
        }
        
        originLabel.text = viewModel.country
        breedNameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        averageWeightLabel.text = viewModel.weight
        lifeSpanLabel.text = viewModel.lifeSpan
        temperamentLabel.text = viewModel.temperament
        
        setChart(characteristics: viewModel.characteristics, values: viewModel.characterLevelArray)
        scrollView.updateContentSize()
        scrollView.setContentOffset(CGPointZero, animated: false)
    }
}

// MARK: - 차트 관련: Configure Chart

extension BreedListController {
    // 차트 구성
    private func setChart(characteristics: [String], values: [Int]) {
        var dataEntries: [RadarChartDataEntry] = []
        
        for i in 0..<characteristics.count {
            let dataEntry = RadarChartDataEntry(value: Double(values[i]))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = RadarChartDataSet(entries: dataEntries)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawValuesEnabled = false
        
        let chartData = RadarChartData(dataSet: chartDataSet)
        
        radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: characteristics)
        radarChartView.data = chartData
        radarChartView.xAxis.spaceMax = 0
        radarChartView.xAxis.spaceMin = 0
    }
}

// MARK: - DropDown 관련: ConfigureDropDown

extension BreedListController {
    // 버튼을 누르면 보여지는 DropDown
    @objc func showDropDown() {
        dropDown.show()
        dropDownIcon.image = UIImage(systemName: "arrowtriangle.up.fill")
    }
    
    private func configureDropDown() {
        // DropDown을 버튼 하단에 위치하게 함
        dropDown.anchorView = changeBreedButton
        dropDown.bottomOffset = CGPoint(x: 0, y: changeBreedButton.bounds.height + 40)
        
        dropDown.textColor = .black // 아이템 텍스트 색상
        dropDown.selectedTextColor = .brown // 선택된 아이템 텍스트 색상
        dropDown.backgroundColor = .white // 아이템 팝업 배경 색상
        dropDown.selectionBackgroundColor = .lightGray // 선택한 아이템 배경 색상
        dropDown.setupCornerRadius(20) // 모서리 둥글게
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

// MARK: - UIScrollView Extension

extension UIScrollView {
    // 계산된 크기를 바탕으로 사이즈를 설정 (scrollViewContainer의 요소들이 모두 할당되면 호출)
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height)
    }
    
    // 스크롤뷰안 컨텐츠의 사이즈를 계산해서 반환
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
}
