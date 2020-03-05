//
//  LoginNavigator.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Foundation

protocol LoginNavigator: Navigator {}

extension LoginNavigator where Self: LoginViewController {
    func openLogin() {
        let viewController = LoginWebViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.completionObservable
            .asObservable()
            .subscribe(onNext: { response in
                viewController.dismiss(animated: true, completion: nil)
                if let response = response {
                    NetworkProvider.shared.jwtToken = response.token
                    self.completionObservable.onNext(())
                    self.completionObservable.onCompleted()
                }
            })
            .disposed(by: viewController.bag)
        
        present(navigationController, animated: true, completion: nil)
    }
}

