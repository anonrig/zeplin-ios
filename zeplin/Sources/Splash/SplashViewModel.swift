import RxSwift
import RxCocoa
import ios_toolkit

final class SplashViewModel: ViewModel, RemoteLoading, ErrorHandler {
    // MARK: - Properties
    var bag: DisposeBag
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private(set) var onError = BehaviorRelay<ErrorObject?>(value: nil)
    private(set) lazy var dataLoadedObservable = PublishSubject<Void>()

    init() {
        bag = DisposeBag()
        
        fetchData()
    }
}

// MARK: - API
extension SplashViewModel: SplashApi {
    func retrieveUser(with jwt: String) -> Observable<User> {
        return NetworkProvider.shared
            .getCurrentUser()
            .do(onError: { error in self.onError.accept(self.handleError(error: error)) })
    }
    
    func fetchData() {
        return Observable
            .just(())
            .flatMap(getAppData)
            .do(onError: { error in self.onError.accept(self.handleError(error: error)) })
            .bind(to: dataLoadedObservable)
            .disposed(by: bag)
    }
}
