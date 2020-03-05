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
import ios_toolkit
import MessageUI
import SafariServices

final class ProfileViewController: UIViewController, View, ErrorDisplayer, LoadingHandler {
    // MARK: - Properties
    private lazy var viewSource = ProfileView()
    
    private(set) var bag: DisposeBag
    private(set) var viewModel: ProfileViewModel
    private(set) var completionObservable = PublishSubject<Void>()
    private(set) var loadingView: LoadingView
    private(set) var logoutObservable = PublishSubject<Void>()
    
    // MARK: - Initialization
    init(with onLogout: PublishSubject<Void>) {
        bag = DisposeBag()
        viewModel = ProfileViewModel()
        loadingView = LoadingView()
        logoutObservable = onLogout
        
        super.init(nibName: nil, bundle: nil)
        
        bindLoading()
        bindErrorHandling()
        observeDatasource()
    }
    
    // MARK: - Life cycle
    override func loadView() {
        view = viewSource
        view.backgroundColor = UIColor(hex: 0x1d1d1d)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar(with: "Profile".localized(), prefersLargeTitle: false)
    }
}

// MARK: - Observe Datasource
extension ProfileViewController: ProfileNavigator {
    private func observeDatasource() {
        viewSource.privacyPolicyButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.showPrivacyPolicy(buttonView: self.viewSource.privacyPolicyButton)
            })
            .disposed(by: viewSource.bag)
        
        viewSource.contactButton.rx.tap
            .asDriver()
            .drive(onNext: self.sendEmail)
            .disposed(by: viewSource.bag)
        
        viewSource.logoutButton.rx.tap
            .asDriver()
            .drive(onNext: self.logout)
            .disposed(by: viewSource.bag)
        
        CurrentUser
            .asObservable()
            .ignoreNil()
            .subscribe(onNext: self.viewSource.populate(with:))
            .disposed(by: viewSource.bag)
    }
}

// MARK: - Mail Composer Delegate
extension ProfileViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SafariViewController Delegate
extension ProfileViewController: SFSafariViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .formSheet
    }
}
