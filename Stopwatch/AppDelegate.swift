import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}
    
    //when it goes background
	func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("going to background")
        let stopWatchVC = (self.window?.rootViewController)! as! StopwatchViewController
        stopWatchVC.startStopBtPress()
        
	}

    //when it comes foreground
	func applicationWillEnterForeground(_ application: UIApplication) {
        
        print("coming to foreground")
        let stopWatchVC = (self.window?.rootViewController)! as! StopwatchViewController
        stopWatchVC.startStopBtPress()
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}

}
