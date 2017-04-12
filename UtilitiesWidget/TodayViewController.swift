//
//  TodayViewController.swift
//  MyLocation
//
//  Created by certainly on 2017/2/27.
//  Copyright © 2017年 certainly. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import AVFoundation
import MediaPlayer

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    @IBOutlet weak var timeText: UIButton!
    //     var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    @IBAction func timerClicked(_ sender: UIButton) {
        openURL("two")
//        counter = counterInital
//        timer.invalidate()
//        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
//        DispatchQueue.global(qos: .background).async {
//            // start the timer
//            self.prepareSound()
//            print("begin async33")
//        }
        
        
    }
    @IBOutlet weak var homeBtn: UIButton!
    
    func openURL(_ msg: String) {
        let path = "todayctl://" + msg
        let url: URL? = URL(string: path)!
        
        if let appurl = url {
            self.extensionContext!.open(appurl,
                                        completionHandler: nil)
        }
  
    }
    
    // called every time interval from the timer
    func timerAction() {
        //        return()
        print("begin play1")
        counter -= 1
        print("begin play2")
        timeText.setTitle("\(counter)", for: UIControlState.normal)
        print("begin play000")
        if counter <= 0 {
            print("begin play111")
            timer.invalidate()
            //            prepareSound()
            print("begin play343243 \(String(describing: soundPlayer))")
            playSound()
            print("begin play333")
        }
    }
    
    func prepareSound() {
        guard let audioFileUrl = Bundle.main.url(forResource: "clair",
                                                 withExtension: "mp3") else {
                                                    print("ctl: nofile")
                                                    return
        }
        
        do {
            print("begin play")
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            soundPlayer?.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
            
        } catch {
            print("Sound player not available: \(error)")
        }
    }
    
    func playSound() {
        soundPlayer?.play()
    }
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    let counterInital = 5
    var counter = 0
    var timer = Timer()
    var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeBtn.layer.masksToBounds = true
        homeBtn.layer.cornerRadius = homeBtn.frame.width/2
        // Do any additional setup after loading the view from its nib.
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        locationManager.delegate = self
        //        locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        var currenSize = self.preferredContentSize
        //        currenSize.height = 200.0
        //        self.preferredContentSize = currenSize
        updateWidget()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        updateWidget()
        completionHandler(NCUpdateResult.newData)
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        currentLocation = locations[0]
    //    }
    //
    //    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //        print(error.localizedDescription)
    //    }
    
    @IBAction func openApp(_ sender: UIButton) {
        //        let url: URL? = URL(string: "location:")!
        let url: URL? = URL(string: "pcast:")!
        
        if let appurl = url {
            self.extensionContext!.open(appurl){
                success in
                print("ctl suc \(success)")
                //                MPRemoteCommandCenter.shared().playCommand
                //                    UIApplication.shared.beginReceivingRemoteControlEvents()
                //                let info = MPNowPlayingInfoCenter.default().debugDescription
                //                let info2 = MPNowPlayingInfoCenter.default().description
                
                //                print("ctl info \(info) | \(info2)")
            }
        }
    }
    func updateWidget()
    {
        //        if currentLocation != nil {
        //            let latitudeText = String(format: "Lat: %.4f",
        //                                      currentLocation!.coordinate.latitude)
        //            
        //            let longitudeText = String(format: "Lon: %.4f",
        //                                       currentLocation!.coordinate.longitude)
        //            
        //            latitudeLabel.text = latitudeText
        //            longitudeLabel.text = longitudeText
        //        }
    }
    @IBAction func goHomeClicked(_ sender: UIButton) {
        openURL("goHome")
//        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
}
