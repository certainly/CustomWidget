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

    
    @IBOutlet weak var switchMode: UISwitch!
    @IBOutlet weak var notifyMode: UILabel!
    let counterInital = 20 * 60
    let VOLUME:Float = 0.5
//    let counterInital = 4 //5 * 60
    var counter = 0
    var timer = Timer()
    var soundPlayer: AVAudioPlayer?
    var volumeView: UIView?
    var originVol: Float?
    var originBright: CGFloat?
    lazy var formatter: DateComponentsFormatter = {
        let fmt = DateComponentsFormatter()
        fmt.allowedUnits = [.second , .minute , .hour]
        return fmt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(x: 20, y: view.frame.size.height  / 3, width: 280, height: 30)
        volumeView = MPVolumeView(frame: rect)
        
        view.addSubview(volumeView!)
        UIApplication.shared.isIdleTimerDisabled = true
        print("ctl 1viewdidload \(AppDelegate.autoStartFlag)")
        switchMode.isOn =  UserDefaults.standard.bool(forKey:  "isMusicModeOn")
         notifyMode.text = switchMode.isOn ? "music" : "vibrate"
        
        
    }
    
//    func get_uuid() -> Bool{
//        let tMode =
//        //判断UserDefaults中是否已经存在
//        if(tMode != nil){
//            return tMode
//        }else{
//            //不存在则生成一个新的并保存
//
//            UserDefaults.standard.set(tMode, forKey: "isMusicModeOn")
//            return tMode
//        }
//    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        notifyMode.text = sender.isOn ? "music" : "vibrate"
        UserDefaults.standard.set(sender.isOn, forKey: "isMusicModeOn")
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var timeText: UIButton!
    @IBAction func timerClicked(_ sender: UIButton) {
        if let _ = soundPlayer?.isPlaying {
            finishPlayer()
        }
        
        if counter == -1 {
            reset()
            return
        }
        if counter != 0  &&  counter != counterInital {
            reset()
            return
        }
        startTimer()



    }
    
    func startTimer()  {
        reset()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
      
        if(switchMode.isOn) {
            prepareSound()
        }
        originBright = UIScreen.main.brightness
        UIScreen.main.brightness = 0.1

    }
    
    func timerAction() {
        counter -= 1
        let formattedTimeLeft = formatter.string(from: TimeInterval(counter))
        timeText.setTitle("\(formattedTimeLeft ?? "blank")", for: UIControlState.normal)
//        print("ctl counter -- \(counter)")
        if counter <= 0 {
            //            counter = -1
            reset()
            counter = -1
            timeText.setTitle("finished", for: UIControlState.normal)
            //            prepareSound()
            if(switchMode.isOn) {
                 playSound()
            } else {
//                let feedbackGenerator = UISelectionFeedbackGenerator()
//                feedbackGenerator.selectionChanged()

               
                 AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
           
            //            timer2.invalidate()
        }
        if counter == (counterInital - 1) {
            setVolumn(VOLUME)
        } else {
//            print("counter = \(counter)")
        }
    }
    
    func reset() {
        timer.invalidate()
        soundPlayer?.stop()
        counter = counterInital
        let formattedTimeLeft = formatter.string(from: TimeInterval(counter))
        timeText.setTitle("\(formattedTimeLeft ?? "blank")", for: UIControlState.normal)
    }
    
    func prepareSound() {
        guard let audioFileUrl = Bundle.main.url(forResource: "clair",
                                                 withExtension: "mp3") else {
                                                    return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            soundPlayer?.delegate = self
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
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
        soundPlayer?.stop()
        soundPlayer = nil
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    private func log(_ msg: String) {
        let alert = UIAlertController(title: "Alert", message: "Message \(msg))", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    private func test() {
        print("ctl ccaa")
    
    }
    
    private func finishPlayer() {
        print("reset originVol to \(String(describing: originVol))")
        if originVol != nil {
            setVolumn(originVol!)
        }
        UIScreen.main.brightness = originBright!
        goHome()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishPlayer()
    }

}

