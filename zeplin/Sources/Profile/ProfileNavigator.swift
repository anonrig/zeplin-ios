//
//  ProfileNavigator.swift
//  zeplin
//
//  Created by yagiz on 3/3/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import SafariServices

protocol ProfileNavigator: Navigator {}

extension ProfileNavigator where Self: ProfileViewController {
    func showPrivacyPolicy(buttonView: UIView) {
        if let `url` = URL(string: "https://api.relevantfruit.com/zeplin/privacy-policy") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let controller = SFSafariViewController(url: url, configuration: config)
            controller.delegate = self
            
            if UIDevice.isRunningOnIpad {
                let halfScreenSize = (UIScreen.main.bounds.width / 1.8)
                let width = halfScreenSize < 500 ? halfScreenSize : 500
                controller.modalPresentationStyle = .popover
                controller.preferredContentSize = CGSize(width: width, height: 700)
                let presentationController = controller.presentationController as! UIPopoverPresentationController
                presentationController.sourceView = buttonView
                presentationController.sourceRect = buttonView.bounds
            }
            
            present(controller, animated: true)
        }
    }
    
    func sendEmail() {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setToRecipients(["hello@relevantfruit.com"])
        viewController.setSubject("Feedback for Zeplin Client")
                
        if MFMailComposeViewController.canSendMail() {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func logout() {
        NetworkProvider.shared.removeToken()
        self.logoutObservable.onNext(())
    }
}

