//
//  ProjectNavigator.swift
//  zeplin
//
//  Created by yagiz on 3/4/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

protocol ProjectNavigator: Navigator {}

extension ProjectNavigator where Self: ProjectViewController {
    func showScreen(_ screen: Screen) {
        let viewController = ScreenViewController(with: screen)
        navigationController?.pushViewController(viewController)
    }
}


