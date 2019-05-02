import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        let controller = TopicListVC()
        let navController = UINavigationController(rootViewController: controller)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor(red: 0.7, green: 0, blue: 0.2, alpha: 1)
        
        return true
    }

}

