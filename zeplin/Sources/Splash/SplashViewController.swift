import UIKit
import RxSwift
import ios_toolkit

final class SplashViewController: UIViewController, View, ErrorDisplayer, LoadingHandler {
    // MARK: - Properties
    private lazy var viewSource = SplashView()
    
    private(set) var bag: DisposeBag
    private(set) var viewModel: SplashViewModel
    private(set) var completionObservable = PublishSubject<Void>()
    private(set) var loadingView: LoadingView
    
    // MARK: - Initialization
    init() {
        bag = DisposeBag()
        viewModel = SplashViewModel()
        loadingView = LoadingView()
        
        super.init(nibName: nil, bundle: nil)
        
        bindLoading()
        bindErrorHandling()
        observeDatasource()
    }
    
    // MARK: - Life cycle
    override func loadView() {
        view = viewSource
      view.backgroundColor = Colors.windowBackgroundBlack.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Observe Datasource
private extension SplashViewController {
    private func observeDatasource() {
        viewModel.dataLoadedObservable
            .bind(to: completionObservable)
            .disposed(by: viewModel.bag)
    }
}
