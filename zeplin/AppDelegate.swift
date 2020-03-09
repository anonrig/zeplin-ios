import UIKit
import RxSwift
import SwifterSwift
import ios_toolkit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var bag: DisposeBag = DisposeBag()
    
    private lazy var appInit: AppInit = {
        let appInit = AppInit()

        appInit.rootControllerDefinedObserver
            .subscribe(onNext: { controller in
                self.window?.rootViewController = controller
            })
            .disposed(by: bag)
        
        return appInit
    }()
    
    private lazy var splashWindow: UIWindow = {
        let window = UIWindow()
        let rootController = SplashViewController()
        
        rootController.completionObservable
            .subscribe(onNext: {
                self.window?.rootViewController = self.appInit.rootController
                self.window?.makeKeyAndVisible()
            })
            .disposed(by: bag)
        
        window.rootViewController = rootController
        window.backgroundColor = Colors.windowBackgroundBlack.color
        window.makeKeyAndVisible()
        return window
    }()
}

// MARK: - App Lifecycle
extension AppDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = splashWindow
        
        UserDefaults.standard.register(defaults: ["UserAgent" :"Mozilla/5.0 (Linux; Android 4.1.1; Galaxy Nexus Build/JRO03C) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19"])
        
        return true
    }
}
