//
//  AppDelegate.swift
//  TodayWidgetUtilities
//
//  Created by certainly on 2017/3/9.
//  Copyright © 2017年 certainly. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var autoStartFlag = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("33dfssdf")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//    func application(_ app: UIApplication,
//                     open url: URL,
//                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        print("App delegate233")
//        return true
//    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        print(url.scheme)
//        print(url.query)
//        return true
//    }
    
//     func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        print("1111qqq")
////        print(url.scheme)
////        print(url.query)
//        return true
//    }
    
//  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//                print("1111qqq")
//        //        print(url.scheme)
//        //        print(url.query)
//                return true
//    }
    
    // [START openurl]
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
//        -> Bool {
//            print("3331111qqq")
//
//            return self.application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: "")
//    }
//    var splitViewController: UISplitViewController {
//        return window!.rootViewController as! UISplitViewController
//    }
//    
//    /// The primary view controller of the split view controller defined in the main storyboard.
//    var primaryViewController: UINavigationController {
//        return  window!.rootViewController.first as! UINavigationController
//    }
    var currentViewController: ViewController? {
        return window!.rootViewController as? ViewController
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
                        print("777133111qqq")
                        print(url)
        if url.description.contains("goHome") {
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        } else {
            currentViewController?.startTimer()
        }
//                        AppDelegate.autoStartFlag = true
                        return true
//        if let invite = FIRInvites.handle(url, sourceApplication:sourceApplication, annotation:annotation) as? FIRReceivedInvite {
//            let matchType =
//                (invite.matchType == .weak) ? "Weak" : "Strong"
//            print("Invite received from: \(sourceApplication) Deeplink: \(invite.deepLink)," +
//                "Id: \(invite.inviteId), Type: \(matchType)")
//            return true
//        }
//        
//        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    // [END openurl]
//    func application(_ application: UIApplication, open urls: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        
//        let obj = urls.absoluteString.components(separatedBy: "://")[1]
//        NotificationCenter.default.post(name: widgetNotificationName, object: obj)
//        print("App delegate")
//        return true
//    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        print("App delegate2")
//        return true
////        let isHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String!, annotation: options[.annotation])
////        return isHandled
//    }
}

