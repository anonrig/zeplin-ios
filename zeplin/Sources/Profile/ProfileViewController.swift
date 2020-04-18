//
//  ProfileViewController.swift
//  zeplin
//
//  Created by yagiz on 3/2/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toolkit
import ToolkitRxSwift
import MessageUI
import SafariServices

final class ProfileViewController: UIViewController, ViewModelBased, LoadableController {
  var LoadingViewType: LoadableView.Type = LoadingView.self
  
  // MARK: - Properties
  lazy var viewSource = ProfileView(user: viewModel.services.preferenceServices.user.value)
  var viewModel: ProfileViewModel!
  let bag = DisposeBag()
  
  // MARK: - Life cycle
  override func loadView() {
    view = viewSource
    view.backgroundColor = Colors.windowBackgroundBlack.color
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavBar(with: "Profile".localized(), prefersLargeTitle: false)
    observeDatasource()
    viewModel.getCurrentUser()
    viewModel.askForRating()
  }
}
// MARK: - Observe Datasource
extension ProfileViewController {
  private func observeDatasource() {
    Observable.merge([
      viewSource.onPrivacyPolicy().asObservable()
        .map { _ in
          ProfileSteps.externalPageRequire(url: URL(string: AppConfig.privacyPolicy.value)!)
        },
      viewSource.onContact().asObservable()
        .map { _ in ProfileSteps.contactRequired },
      viewSource.onLogout().asObservable()
        .map { _ in ProfileSteps.logoutRequired}
    ])
      .asObservable()
      .observeOn(MainScheduler.instance)
      .do(onNext: { self.viewModel.actionRequired($0) })
      .subscribe()
      .disposed(by: viewSource.bag)
  }
}
