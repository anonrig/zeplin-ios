//
//  NetworkProvider.swift
//  qrtfy
//
//  Created by yagiz on 2/2/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import UIKit
import Toolkit
import RxSwift
import Moya
import RxMoya
import RxMoya_ModelMapper

final class NetworkProvider {
    static let shared = NetworkProvider()
    
    let provider = MoyaProvider<ZeplinService>()
            
    var jwtToken: String? {
        get {
            if let jwt = Keychain.get(.token) {
                return jwt.value
            }
            
            return nil
        } set {
            if let value = newValue {
                Keychain.save(credentials: [.token(value)])
            }
        }
    }
    
    func removeToken() {
        Keychain.delete([.token])
    }

    func getCurrentUser() -> Observable<User> {
        return provider.rx.request(.getCurrentUser)
            .map(to: User.self, keyPath: "user")
            .asObservable()
    }
    
    func getProjects() -> Observable<[Project]> {
        return provider.rx.request(.getProjects)
            .map(to: [Project].self, keyPath: "projects")
            .asObservable()
    }
    
    func getScreens(for project: Project) -> Observable<[ScreenSection]> {
        return provider.rx.request(.getScreens(project: project))
            .map(to: [ScreenSection].self, keyPath: "sections")
            .asObservable()
    }
    
    func deleteScreen(for screen: Screen, with project: Project) -> Observable<Void> {
        return provider.rx.request(.deleteScreen(screen: screen, project: project))
            .map { _ in }
            .asObservable()
    }
}
