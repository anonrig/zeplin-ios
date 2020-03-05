import UIKit
import RxSwift
import RxCocoa
import ios_toolkit

final class LoginViewController: UIViewController, View, ErrorDisplayer, LoadingHandler {
    // MARK: - Properties
    private lazy var viewSource = LoginView()
    
    private(set) var bag: DisposeBag
    private(set) var viewModel: LoginViewModel
    private(set) var completionObservable = PublishSubject<Void>()
    private(set) var loadingView: LoadingView
    
    // MARK: - Initialization
    init() {
        bag = DisposeBag()
        viewModel = LoginViewModel()
        loadingView = LoadingView()
        
        super.init(nibName: nil, bundle: nil)
        
        bindLoading()
        bindErrorHandling()
        observeDatasource()
    }
    
    // MARK: - Life cycle
    override func loadView() {
        view = viewSource
        view.backgroundColor = UIColor(hex: 0x1d1d1d)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Observe Datasource
extension LoginViewController: LoginNavigator {
    private func observeDatasource() {
        viewSource.loginButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.openLogin()
//                self.completionObservable.onNext(())
            })
            .disposed(by: viewSource.bag)
    }
}
