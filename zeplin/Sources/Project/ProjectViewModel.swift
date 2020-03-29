//
//  ProjectViewModel.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxCocoa
import Toolkit

final class ProjectViewModel: ViewModel, RemoteLoading, ErrorHandler {
    // MARK: - Properties
    var bag: DisposeBag
    private(set) var isLoading = BehaviorRelay<Bool>(value: true)
    private(set) var onError = BehaviorRelay<ErrorObject?>(value: nil)
    private(set) var sections = BehaviorRelay<[ScreenSection]>(value: [])
    private(set) var project: BehaviorRelay<Project>
    private(set) var editModeEnabled = BehaviorRelay<Bool>(value: false)
    private(set) var selectedScreens = BehaviorRelay<[Screen]>(value: [])
    private(set) var isRefreshing = BehaviorRelay<Bool>(value: false)
    
    init(with project: Project) {
        bag = DisposeBag()
        self.project = BehaviorRelay<Project>(value: project)
        
        getScreens()
    }
}

// MARK: - Fetch resource
extension ProjectViewModel {
    func getScreens(isRefresh: Bool = false) {
        let loadingHandler = isRefresh ? isRefreshing : isLoading

        Observable.just((project.value))
            .do(onNext: { _ in loadingHandler.accept(true) })
            .flatMap(NetworkProvider.shared.getScreens)
            .do(onNext: { _ in loadingHandler.accept(false) })
            .catchError({ error -> Observable<[ScreenSection]> in
                self.onError.accept(self.handleError(error: error))
                loadingHandler.accept(false)
                return .just([])
            })
            .bind(to: sections)
            .disposed(by: bag)
    }
}
