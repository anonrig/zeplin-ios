import RxSwift
import RxCocoa
import Kingfisher
import Toolkit

protocol SplashApi {}

let CurrentUser = BehaviorRelay<User?>(value: nil)

extension SplashApi where Self: SplashViewModel {
    func getAppData() -> Observable<Void> {
        return Observable.zip([getCurrentUser()])
            .map { _ in }
    }

    private func getCurrentUser() -> Observable<Void> {
        guard let jwt = NetworkProvider.shared.jwtToken else {
            return Observable.just(()).delay(1, scheduler: MainScheduler.instance)
        }
        
        return retrieveUser(with: jwt)
            .map { CurrentUser.accept($0) }
            .catchErrorJustReturn(())
    }
}
