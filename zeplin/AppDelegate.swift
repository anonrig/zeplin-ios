import UIKit
import RxSwift
import RxFlow
import Toolkit
import OneSignal
import Sentry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  let bag = DisposeBag()
  let appServices = AppServices()
  let coordinator = FlowCoordinator()
}

// MARK: - App Lifecycle
extension AppDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    
    if let window = window {
      let appFlow = AppFlow(window: window, services: appServices)
      coordinator.coordinate(flow: appFlow, with: AppStepper(withServices: self.appServices))
    }
    
    let _ = SentrySDK(options: ["dsn": AppConfig.sentryDsn])
    OneSignal.initWithLaunchOptions([kOSSettingsKeyAutoPrompt: false], appId: AppConfig.oneSignalId.value)
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    appServices.handleDeepLink(for: url)
    return true
  }
}
