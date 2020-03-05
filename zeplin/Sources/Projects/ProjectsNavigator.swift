//
//  ProjectNavigator.swift
//  zeplin
//
//  Created by yagiz on 3/1/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Foundation

protocol ProjectsNavigator: Navigator {}

extension ProjectsNavigator where Self: ProjectsViewController {
    func showProject(_ project: Project) {
        let viewController = ProjectViewController(with: project)
        navigationController?.pushViewController(viewController)
    }
    
    func showNotifications() {
        let viewController = NotificationsViewController()
        navigationController?.pushViewController(viewController)
    }
    
    func showProfile() {
        let viewController = ProfileViewController(with: self.logoutObservable)
        navigationController?.pushViewController(viewController)
    }
}


