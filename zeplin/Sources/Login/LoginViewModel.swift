import RxSwift
import RxCocoa
import Toolkit

final class LoginViewModel: ViewModel, RemoteLoading, ErrorHandler {
    // MARK: - Properties
    var bag: DisposeBag
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var onError = BehaviorRelay<ErrorObject?>(value: nil)
    
    init() {
        bag = DisposeBag()
    }
}
