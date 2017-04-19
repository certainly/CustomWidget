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

class ViewController: UIViewController, AVAudioPlayerDelegate {

    
    let counterInital = 20 * 60
    let VOLUME:Float = 0.4
//    let counterInital = 10 //5 * 60
    var counter = 0
    var timer = Timer()
    var soundPlayer: AVAudioPlayer?
    var volumeView: UIView?
    var originVol: Float?
    var originBright: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(x: 20, y: view.frame.size.height  / 3, width: 280, height: 30)
        volumeView = MPVolumeView(frame: rect)
        
        view.addSubview(volumeView!)
        UIApplication.shared.isIdleTimerDisabled = true
        print("ctl 1viewdidload \(AppDelegate.autoStartFlag)")
//        if(AppDelegate.autoStartFlag) {
//            AppDelegate.autoStartFlag = false
//            startTimer()
//        }
//        test()
        // Do any additional setup after loading the view, typically from a nib.
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
        prepareSound()
        originBright = UIScreen.main.brightness
        UIScreen.main.brightness = 0.1

    }
    
    func timerAction() {
        counter -= 1
        timeText.setTitle("\(counter)", for: UIControlState.normal)
        print("ctl counter -- \(counter)")
        if counter <= 0 {
            //            counter = -1
            reset()
            counter = -1
            timeText.setTitle("finished", for: UIControlState.normal)
            //            prepareSound()
            playSound()
            //            timer2.invalidate()
        }
    }
    
    func reset() {
        timer.invalidate()
        soundPlayer?.stop()
        counter = counterInital
        timeText.setTitle("\(counter)", for: UIControlState.normal)
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
            setVolumn(VOLUME)
            
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

