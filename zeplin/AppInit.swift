import UIKit
import RxSwift

struct AppInit {
    // MARK - Properties
    private(set) var rootControllerDefinedObserver = PublishSubject<UIViewController>()
}

// MARK: - External Workers
extension AppInit {
    var rootController: UIViewController {
        return NetworkProvider.shared.jwtToken != nil ? projectsController : loginController
    }
    
    var loginController: UIViewController {
        let viewController = LoginViewController()

        viewController.completionObservable
            .asObservable()
            .single()
            .subscribe(onNext: { _ in
                self.rootControllerDefinedObserver.onNext(self.projectsController)
            })
            .disposed(by: viewController.bag)
        
        return viewController
    }
    
    var projectsController: UINavigationController {
        let viewController = ProjectsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setupStyling()
        
        viewController.logoutObservable
            .asObservable()
            .single()
            .subscribe(onNext: { _ in
                self.rootControllerDefinedObserver.onNext(self.loginController)
            })
            .disposed(by: viewController.bag)

        return navigationController
    }
}
