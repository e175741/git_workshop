//
//  ViewController.swift
//  test_music
//
//  Created by 佐久川　政樹 on 2018/11/05.
//  Copyright © 2018 佐久川　政樹. All rights reserved.
//

import UIKit
import MediaPlayer
import Foundation
import AVFoundation



class ViewController: UIViewController {
    var player = MPMusicPlayerController.systemMusicPlayer
    
    var Item = MPMediaItem()
    
    var Avaudio = AVAudioPlayer()
    
    var timer = Timer()

    
    //var query = MPMediaQuery.songs()
    @IBOutlet weak var TotalTime: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    
    @IBAction func previous(_ sender: Any) {
        //戻るボタン
        player.skipToPreviousItem()
    }
    
    @IBAction func playb(_ sender: Any) {
        //プレイボタン
        player.play()
    }
    
    @IBAction func stop(_ sender: Any) {
        //ストップボタン
        player.stop()
    }
    
    @IBAction func next(_ sender: Any) {
        //スキップボタン
        player.skipToNextItem()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //currentTimeを0.5秒ごとに実行
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:#selector(self.currentTime), userInfo: nil, repeats: true)
        
        //トータル時間を取得
        TotalTime.text = formatTimeString(d: Item.playbackDuration)
        
    }
    
    
    @objc func currentTime(){
        //現在の再生時間
        time.text = formatTimeString(d: player.currentPlaybackTime)
    }
    
    
    func formatTimeString(d: Double) -> String{
        //TimeIntervalからStringへ変換 & 00:00 の形式に直す
        let s:Int = Int(d.truncatingRemainder(dividingBy: 60))
        let m:Int = Int(((d - Double(s)) / 60).truncatingRemainder(dividingBy: 60))
        let time:String = String(format: "%02d:%02d" ,m,s)
        return time
    }
    
}

