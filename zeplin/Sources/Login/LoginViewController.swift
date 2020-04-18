import UIKit
import RxSwift
import RxCocoa
import Toolkit
import ToolkitRxSwift

final class LoginViewController: UIViewController, ViewModelBased, LoadableController {
  //MARK: - Properties
  var LoadingViewType: LoadableView.Type = LoadingView.self
  
  var viewModel: LoginViewModel!
  let viewSource = LoginView()
  let bag = DisposeBag()
  
  // MARK: - Life cycle
  override func loadView() {
    view = viewSource
    view.backgroundColor = Colors.windowBackgroundBlack.color
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    observeDatasource()
  }
}

// MARK: - Observe Datasource
extension LoginViewController {
  private func observeDatasource() {
    viewSource.onLogin()
      .asDriver()
      .do(onNext: { _ in self.viewModel.webLoginRequired() })
      .drive()
      .disposed(by: viewSource.bag)
  }
}
