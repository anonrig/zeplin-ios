//
//  ScreenViewController.swift
//  zeplin
//
//  Created by yagiz on 3/4/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import RxSwift
import ios_toolkit
import Kingfisher

final class ScreenViewController: UIViewController, ios_toolkit.View, ErrorDisplayer, LoadingHandler {
    // MARK: - Properties
    private lazy var viewSource = ScreenView()
    
    private(set) var bag: DisposeBag
    private(set) var viewModel: ScreenViewModel
    private(set) var completionObservable = PublishSubject<Void>()
    private(set) var loadingView: LoadingView
    
    // MARK: - Initialization
    init(with screen: Screen) {
        bag = DisposeBag()
        viewModel = ScreenViewModel(with: screen)
        loadingView = LoadingView()
        
        super.init(nibName: nil, bundle: nil)
        
        bindLoading()
        bindErrorHandling()
        observeDatasource()
    }
    
    // MARK: - Life cycle
    override func loadView() {
        view = viewSource
      view.backgroundColor = Colors.windowBackgroundBlack.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar(with: viewModel.screen.value.name ?? "", prefersLargeTitle: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewSource.screenModeButton)
        viewSource.screenModeButton.snp.makeConstraints { $0.width.equalTo(60) }
        
        Observable.just((viewModel.screen.value.image?.original_url))
            .ignoreNil()
            .map { URL(string: $0) }
            .ignoreNil()
            .flatMap { self.viewSource.screenImage.kf.rx.setImage(with: $0) }
            .subscribe(onNext: { image in
                self.setZoom(forOriginal: true)
            })
            .disposed(by: bag)
    }
}

// MARK: - Observe Datasource
private extension ScreenViewController {
    private func observeDatasource() {
        viewSource.imageScrollView.rx.setDelegate(self)
            .disposed(by: viewSource.bag)

        viewSource.screenModeButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                let newValue = !self.viewModel.isOriginalMode.value
                self.viewModel.isOriginalMode.accept(newValue)
                
                self.setZoom(forOriginal: newValue)
            })
            .disposed(by: viewSource.bag)
        
        viewModel.isOriginalMode
            .asObservable()
            .map { $0 ? "Original".localized() : "Fit".localized() }
            .bind(to: viewSource.screenModeButton.rx.title())
            .disposed(by: viewModel.bag)
        
        let eventGesture = UITapGestureRecognizer()
        eventGesture.numberOfTouchesRequired = 1
        viewSource.imageScrollView.addGestureRecognizer(eventGesture)
        
        eventGesture.rx.event
            .asDriver()
            .drive(onNext: { _ in
                guard let navbar = self.navigationController?.navigationBar else { return }
                self.navigationController?.setNavigationBarHidden(!navbar.isHidden, animated: true)
            })
            .disposed(by: bag)
        
    }
}

extension ScreenViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewSource.screenImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setScrollViewZoom(for: scrollView)
    }
    
    private func setScrollViewZoom(for scrollView: UIScrollView) {
        let offsetX = max((UIScreen.main.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((UIScreen.main.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)

        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
    private func setZoom(forOriginal: Bool = false) {
        viewSource.imageScrollView.layoutSubviews()

        let minZoom = min(min(UIScreen.main.bounds.width / viewSource.screenImage.bounds.size.width, UIScreen.main.bounds.height / viewSource.screenImage.bounds.size.height), 1.0)

        viewSource.imageScrollView.minimumZoomScale = forOriginal ? minZoom * 0.9 : minZoom
        viewSource.imageScrollView.zoomScale = forOriginal ? minZoom * 0.9 : minZoom
        setScrollViewZoom(for: viewSource.imageScrollView)
    }
}
