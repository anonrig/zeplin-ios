//
//  ScreenViewController.swift
//  zeplin
//
//  Created by yagiz on 3/4/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import RxSwift
import Toolkit
import Kingfisher

final class ScreenViewController: UIViewController, ViewModelBased {
  
  // MARK: - Properties
  var viewModel: ScreenViewModel!
  let viewSource = ScreenView()
  let bag = DisposeBag()
  
  override var prefersStatusBarHidden: Bool {
    return viewModel.statusBarHidden.value
  }
  
  // MARK: - Life cycle
  override func loadView() {
    view = viewSource
    view.backgroundColor = Colors.windowBackgroundBlack.color
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavBar(with: viewModel.screen.name ?? "", prefersLargeTitle: false)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewSource.screenModeButton)

    observeDatasource()

    viewModel.getImage()
      .asObservable()
      .ignoreNil()
      .do(onNext: {
        self.viewSource.screenImage.image = $0
        self.viewSource.layoutIfNeeded()
      })
      .catchError({ (error) -> Observable<UIImage> in
        self.rx.showAlert.onNext(.init(message: "An error has occurred, please try again later.".localized()))
        return .just(.init())
      })
      .subscribe(onNext: { _ in self.setZoom(forOriginal: true) })
      .disposed(by: viewModel.bag)
  }
}

// MARK: - Observe Datasource
private extension ScreenViewController {
  private func observeDatasource() {
    viewModel.statusBarHidden
      .asDriver()
      .distinctUntilChanged()
      .drive(onNext: { [weak self] _ in
        self?.setNeedsStatusBarAppearanceUpdate()
      })
      .disposed(by: viewModel.bag)
    
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
      .map { $0 ? "Fit".localized() : "Original".localized() }
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
        self.viewModel.toggleStatusBar()
        self.setZoom(forOriginal: self.viewModel.isOriginalMode.value)
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
