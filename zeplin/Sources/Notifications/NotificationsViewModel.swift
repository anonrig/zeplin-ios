//
//  NotificationsViewModel.swift
//  zeplin
//
//  Created by yagiz on 3/2/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxCocoa
import ios_toolkit

final class NotificationsViewModel: ViewModel, RemoteLoading, ErrorHandler {
    // MARK: - Properties
    var bag: DisposeBag
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var onError = BehaviorRelay<ErrorObject?>(value: nil)
    
    init() {
        bag = DisposeBag()
    }
}
