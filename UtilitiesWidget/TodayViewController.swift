//
//  TodayViewController.swift
//  MyLocation
//
//  Created by certainly on 2017/2/27.
//  Copyright © 2017年 certainly. All rights reserved.
//

import UIKit
import NotificationCenter
import MediaPlayer
import StoreKit

class TodayViewController: UIViewController, NCWidgetProviding {



    




    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWidget()
    }



    
    @IBOutlet var btns: [UIButton]!
    @IBAction func playbtnPressed(_ sender: UIButton) {
        playMusic(sender)
    }

    @IBAction func openApp(_ sender: UIButton) {
        //        let url: URL? = URL(string: "location:")!
//        let url: URL? = URL(string: "pcast:")!
//        print("se \(sender.currentTitle)")
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
        preferredContentSize = CGSize(width: maxSize.width, height: 320.0)
//        if activeDisplayMode == .expanded {
//            //             preferredContentSize = maxSize
//            preferredContentSize = CGSize(width: maxSize.width, height: 320.0)
//            print("preferredContentSize = \(preferredContentSize)")
//        } else if activeDisplayMode == .compact {
////            preferredContentSize = CGSize(width: 0.0, height: 300.0)
////                        preferredContentSize = maxSize
//                preferredContentSize = CGSize(width: maxSize.width, height: 320.0)
//        }
    }
    
    func playMusic(_ sender: UIButton) {
        if  appleMusicRequestPermission() {
            
            playMyList(sender)
        }
    }
    
    func requestAppleMusicPermission() {
        SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
            
            switch status {
                
            case .authorized:
                
                print("All good - the user tapped 'OK', so you're clear to move forward and start playing.")
                
                
            case .denied:
                
                print("The user tapped 'Don't allow'. Read on about that below...")
                
            case .notDetermined:
                
                print("The user hasn't decided or it's not clear whether they've confirmed or denied.")
                
            default: break
                
            }
            
        }

    
    }
    
    func appleMusicRequestPermission() -> Bool {
        
        switch SKCloudServiceController.authorizationStatus() {
            
        case .authorized:
            
            print("The user's already authorized - we don't need to do anything more here, so we'll exit early.")
            return true
            
        case .denied:
            
            print("The user has selected 'Don't Allow' in the past - so we're going to show them a different dialog to push them through to their Settings page and change their mind, and exit the function early.")
            
            // Show an alert to guide users into the Settings
            
            return false
            
        case .notDetermined:
            
            print("The user hasn't decided yet - so we'll break out of the switch and ask them.")
            requestAppleMusicPermission()
            return false
            
        case .restricted:
            
            print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
            return false
            
        }
        
        
    }
    
    private func playMyList(_ sender: UIButton) {
        let player =  MPMusicPlayerController.systemMusicPlayer()
        if let _ = player.nowPlayingItem {
            player.stop()
            sender.setImage(#imageLiteral(resourceName: "applemusic"), for: .normal)
            return
        }
        let query: MPMediaQuery = MPMediaQuery.playlists()
        let playlists = query.collections
        guard playlists != nil else {
            return
        }
        var name: String
        for collection in playlists!
        {
            //            print(playlists?.debugDescription)
            name = collection.value(forProperty: MPMediaPlaylistPropertyName) as! String
            print(name)
            if name == "arecertainly" {
                player.stop()
                player.setQueue(with: collection)
                player.play()
                sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                break
            }
        }
        
    }
    

}
