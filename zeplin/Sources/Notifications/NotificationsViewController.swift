//
//  NotificationsViewController.swift
//  zeplin
//
//  Created by yagiz on 3/2/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import RxSwift
import ios_toolkit

final class NotificationsViewController: UIViewController, View, ErrorDisplayer, LoadingHandler {
    // MARK: - Properties
    private lazy var viewSource = NotificationsView()
    
    private(set) var bag: DisposeBag
    private(set) var viewModel: NotificationsViewModel
    private(set) var loadingView: LoadingView
    
    // MARK: - Initialization
    init() {
        bag = DisposeBag()
        viewModel = NotificationsViewModel()
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
        
        configureNavBar(with: "Notifications".localized(), prefersLargeTitle: false)
    }
}

// MARK: - Observe Datasource
private extension NotificationsViewController {
    private func observeDatasource() {

    }
}
