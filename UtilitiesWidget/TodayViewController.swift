//
//  TodayViewController.swift
//  MyLocation
//
//  Created by certainly on 2017/2/27.
//  Copyright © 2017年 certainly. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {



    



    
    override func viewDidLoad() {
        super.viewDidLoad()
//        homeBtn.layer.masksToBounds = true
//        homeBtn.layer.cornerRadius = homeBtn.frame.width/2
        // Do any additional setup after loading the view from its nib.
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        locationManager.delegate = self
        //        locationManager.requestLocation()
         updateWidget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        var currenSize = self.preferredContentSize
        //        currenSize.height = 200.0
        //        self.preferredContentSize = currenSize
       
    }

    
//    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        // Perform any setup necessary in order to update the view.
//        
//        // If an error is encountered, use NCUpdateResult.Failed
//        // If there's no update required, use NCUpdateResult.NoData
//        // If there's an update, use NCUpdateResult.NewData
//        updateWidget()
//        completionHandler(NCUpdateResult.newData)
//    }
    
    @IBOutlet var btns: [UIButton]!

    @IBAction func openApp(_ sender: UIButton) {
        //        let url: URL? = URL(string: "location:")!
//        let url: URL? = URL(string: "pcast:")!
        print("se \(sender.currentTitle)")
         let url: URL? = URL(string: sender.currentTitle!)!
        if let appurl = url {
            self.extensionContext!.open(appurl){
                success in
                print("ctl suc \(success)")

            }
        }
    }
    
    
    func updateWidget()
    {

        if #available(iOSApplicationExtension 10.0, *) { // Xcode would suggest you implement this.
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        } else {
            // Fallback on earlier versions
        }
        for button in btns {
            //            button.contentHorizontalAlignment = .fill
            //            button.contentVerticalAlignment = .fill
            //            button.contentMode = .scaleAspectFit
//            print("ctl dd\(button)")
            button.imageView?.contentMode = .scaleAspectFit
        }

    }
    

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        print("widgetActiveDisplayModeDidChange iii")
//         preferredContentSize = CGSize(width: 0.0, height: 300.0)
        if activeDisplayMode == .expanded {
            //             preferredContentSize = maxSize
            preferredContentSize = CGSize(width: 0.0, height: 320.0)
            print("preferredContentSize = \(preferredContentSize)")
        } else if activeDisplayMode == .compact {
//            preferredContentSize = CGSize(width: 0.0, height: 300.0)
                        preferredContentSize = maxSize
        }
    }
    
    

}
