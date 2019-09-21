//
//  ViewController.swift
//  TodayWidgetUtilities
//
//  Created by certainly on 2017/3/9.
//  Copyright © 2017年 certainly. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AudioToolbox

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var modeSegment: UISegmentedControl!
    

    let counterInital =  20 * 60
    let VOLUME:Float = 0.5
//    let counterInital = 4 //5 * 60
    var counter = 0
    var timer = Timer()
    var soundPlayer: AVAudioPlayer?
    var volumeView: UIView?
    var originVol: Float?
    var originBright: CGFloat?
    var isMusicOn = false
    
    lazy var formatter: DateComponentsFormatter = {
        let fmt = DateComponentsFormatter()
        fmt.allowedUnits = [.second , .minute , .hour]
        return fmt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(x: 20, y: view.frame.size.height  / 2, width: 280, height: 30)
        volumeView = MPVolumeView(frame: rect)
        
        view.addSubview(volumeView!)
        UIApplication.shared.isIdleTimerDisabled = true
        print("ctl 1viewdidload \(AppDelegate.autoStartFlag)")
         isMusicOn =  UserDefaults.standard.bool(forKey:  "isMusicModeOn")
        modeSegment.selectedSegmentIndex = isMusicOn ? 0 : 1
//        originBright = UIScreen.main.brightness
        print("isMusic  to \(isMusicOn)")

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeAlive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    // my selector that was defined above
    @objc func appDidBecomeAlive() {
        originBright = UIScreen.main.brightness
        print("appDidBecomeAlive...\(originBright)")
        UIScreen.main.brightness = 0.1
    }



    @IBAction func switchSegmentChanged(_ sender: UISegmentedControl) {
        isMusicOn = sender.selectedSegmentIndex == 0 ? true : false
        print("isMusic on changed to \(isMusicOn)")
        UserDefaults.standard.set(isMusicOn, forKey: "isMusicModeOn")
    }
    

    @IBAction func settingBtnTapped(_ sender: Any) {
          performSegue(withIdentifier: "TimerSettingSegue", sender: nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var timeText: UIButton!
    @IBAction func timerClicked(_ sender: UIButton) {
        if let _ = soundPlayer?.isPlaying {
           goHome()
        } else if counter == -1 {
            reset()
        } else  if counter != 0  &&  counter != counterInital {
            reset()
        } else {
            startTimer()
        }



    }
    
    func startTimer()  {
        reset()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
      

//        originBright = UIScreen.main.brightness
//        UIScreen.main.brightness = 0.1

    }
    
    @objc func timerAction() {
        counter -= 1
        let formattedTimeLeft = formatter.string(from: TimeInterval(counter))
        timeText.setTitle("\(formattedTimeLeft ?? "blank")", for: UIControl.State.normal)
//        print("ctl counter -- \(counter)")
        if counter <= 0 {
            //            counter = -1
            reset()
            counter = -1
            timeText.setTitle("finished", for: UIControl.State.normal)

            if(isMusicOn) {
                prepareSound()
                 playSound()
            } else {


                [0,3,5,7,9,11,13].forEach{ Timer.scheduledTimer(timeInterval: $0, target: self, selector: #selector(vibrate), userInfo: nil, repeats: false)      }
//                goHome()

            }
           
            //            timer2.invalidate()
        }
        if counter == (counterInital - 1) {
            setVolumn(VOLUME)
        } else {
//            print("counter = \(counter)")
        }
    }
    
    @objc func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func reset() {
        timer.invalidate()
        soundPlayer?.stop()
        counter = counterInital
//        let formattedTimeLeft = "28:00"
        let formattedTimeLeft = formatter.string(from: TimeInterval(counter)) ?? "blank"
        if let _ = timeText {

            timeText.setTitle(formattedTimeLeft, for: UIControl.State.normal)
        }
    }
    
    func prepareSound() {
        guard let audioFileUrl = Bundle.main.url(forResource: "clair",
                                                 withExtension: "mp3") else {
                                                    return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            soundPlayer?.delegate = self
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            //            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            //            MPMusicPlayerController.applicationMusicPlayer()
            soundPlayer?.prepareToPlay()
//            setVolumn(VOLUME)
            
//            soundPlayer?.setVolume(1.0, fadeDuration: 1.5)
        } catch {
            print("Sound player not available: \(error)")
        }
    }
    
    private func setVolumn(_ vol: Float) {
        if volumeView?.subviews != nil {
            
            for subview in (volumeView?.subviews)! {
                print("ctl sub:  \(subview.description)")
                
                if subview.description.contains("MPVolumeSlider") {
                    let slider = subview as? UISlider
                    print("ctl slider: \(String(describing: slider?.value))")
                    //                        log("\(slider?.value)")
                    
                    if let xx = slider?.value{
                        slider?.value = vol
                         originVol = xx
//                        if xx != 0.0 {
//
//                            originVol = xx
//                        } else {
////                            originVol = 1
//                        }
                        
                        
                    }
                    print("ctl slider2: \(String(describing: slider?.value))")
                }
            }
        }
        
    }
    
    func playSound() {
        print("ctl play \(String(describing: soundPlayer))")
        soundPlayer?.play()
    }

    @IBAction func btnClicked(_ sender: UIButton) {
        goHome()
    }
    
    private func goHome() {
        print("reset originVol to \(String(describing: originVol))")
        if originVol != nil {
            setVolumn(originVol!)
        }
        UIScreen.main.brightness = originBright ?? 10
        soundPlayer?.stop()
        soundPlayer = nil
        reset()
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    private func log(_ msg: String) {
        let alert = UIAlertController(title: "Alert", message: "Message \(msg))", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    private func test() {
        print("ctl ccaa")
    
    }
    

    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        goHome()
    }

}

