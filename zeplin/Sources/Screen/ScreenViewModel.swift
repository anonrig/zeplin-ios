//
//  ScreenViewModel.swift
//  zeplin
//
//  Created by yagiz on 3/4/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxCocoa
import Toolkit

final class ScreenViewModel: ViewModel, RemoteLoading, ErrorHandler {
    // MARK: - Properties
    var bag: DisposeBag
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var onError = BehaviorRelay<ErrorObject?>(value: nil)
    private(set) var screen: BehaviorRelay<Screen>
    private(set) var isOriginalMode = BehaviorRelay<Bool>(value: true)
    
    init(with currentScreen: Screen) {
        screen = BehaviorRelay<Screen>(value: currentScreen)
        bag = DisposeBag()
    }
}

