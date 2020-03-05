//
//  NetworkProvider.swift
//  qrtfy
//
//  Created by yagiz on 2/2/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import UIKit
import ios_toolkit
import RxSwift
import KeychainSwift
import Alamofire

class NetworkProvider {
    static let shared = NetworkProvider()
    
    let manager = SessionManager.default
    
    let baseUrl = "https://api.relevantfruit.com/v1/zeplin/"
    
    private var keychain = KeychainSwift()
    
    var jwtToken: String? {
        get {
            if let jwt = keychain.get("jwt") {
                return jwt
            }
            
            return nil
        } set {
            if let value = newValue {
                keychain.set(value, forKey: "jwt")
            }
        }
    }
    
    func getCurrentUser() -> Observable<User> {
        let url = baseUrl + "user/me"
        let headers = self.getHeaders()
        
        return manager.rx.request(.get, url, parameters: [:], encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseMappable(as: User.self, keyPath: "user")
    }
    
    func getProjects() -> Observable<[Project]> {
        let url = baseUrl + "projects"
        let headers = self.getHeaders()
        
        return manager.rx.request(.get, url, parameters: [:], encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseMappableArray(as: Project.self, keyPath: "projects")
    }
    
    func getScreens(for project: Project) -> Observable<[ScreenSection]> {
        let url = baseUrl + "projects/\(project.id ?? "")/screens"
        let headers = self.getHeaders()
        
        return manager.rx.request(.get, url, parameters: [:], encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseMappableArray(as: ScreenSection.self, keyPath: "sections")
    }
    
    func deleteScreen(for screen: Screen, with project: Project) -> Observable<Void> {
        let url = baseUrl + "projects/\(project.id ?? "")/screens/\(screen.id ?? "")"
        let headers = self.getHeaders()
        print("url", url)
        return manager.rx.request(.delete, url, parameters: [:], encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .map { _ in }
    }
    
    private func getHeaders() -> [String: String] {
        guard let token = self.jwtToken else {
            return [:]
        }

        return [
            "Authorization": token
        ]
    }
}
