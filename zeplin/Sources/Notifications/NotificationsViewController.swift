//
//  NotificationsViewController.swift
//  zeplin
//
//  Created by yagiz on 3/2/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import RxSwift
import Toolkit
import ToolkitRxSwift

final class NotificationsViewController: UIViewController, ViewModelBased, LoadableController {
  var LoadingViewType: LoadableView.Type = LoadingView.self
  
  // MARK: - Properties
  let viewSource = NotificationsView()
  var viewModel: NotificationsViewModel!
  let bag = DisposeBag()
  
  // MARK: - Life cycle
  override func loadView() {
    view = viewSource
    view.backgroundColor = Colors.windowBackgroundBlack.color
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavBar(with: "Notifications".localized(), prefersLargeTitle: false)
  }
}
