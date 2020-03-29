import UIKit
import RxSwift
import SwifterSwift
import Toolkit
import OneSignal

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
        
        let onesignalSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(onesignalSettings, appId: "3b3075a1-b7b0-4f9a-a72c-2856fa865ca4")
        return true
    }
}
