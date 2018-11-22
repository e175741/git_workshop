//
//  ViewController.swift
//  test_music
//
//  Created by 佐久川　政樹 on 2018/11/05.
//  Copyright © 2018 佐久川　政樹. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, AVAudioPlayerDelegate,MPMediaPickerControllerDelegate {
    
    var audioPlayer:AVAudioPlayer!
    var timer = Timer()
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    @IBOutlet weak var cTime: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var play: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "sample2", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        
        //currentTimeを0.5秒ごとに実行
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:#selector(self.CurrentTime), userInfo: nil, repeats: true)
        //progressViewを0.001秒ごとに実行
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector:#selector(self.progressView), userInfo: nil, repeats: true)
        
        //トータル時間の取得
        duration.text = formatTimeString(d: audioPlayer.duration)
        
        
        
    }
    
    // ボタンがタップされた時の処理
    @IBAction func buttonTapped(_ sender : AnyObject) {
        if ( audioPlayer.isPlaying ){
            audioPlayer.stop()
            play.setTitle("Play", for: UIControl.State())
        }
        else{
            audioPlayer.play()
            play.setTitle("Stop", for: UIControl.State())
        }
    }
    
    @objc func progressView(){
        let currentTime = audioPlayer.currentTime / audioPlayer.duration
        progress.setProgress(Float(currentTime),animated: true)
    }
 
  
    
    // メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection)  {
        
        // プレイヤーを止める
        audioPlayer.stop()
        
        // 選択した曲情報がmediaItemCollectionに入っているので、これをplayerにセット。
        musicPlayer.setQueue(with: mediaItemCollection)
        
        
        // ピッカーを閉じる
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じる
        dismiss(animated: true, completion: nil)
    }
    
    @objc func CurrentTime(){
        //現在の再生時間
        cTime.text = formatTimeString(d:audioPlayer.currentTime)
    }
    
    
    func formatTimeString(d: Double) -> String{
        //TimeIntervalからStringへ変換,00:00の形式に直す
        let s:Int = Int(d.truncatingRemainder(dividingBy: 60))
        let m:Int = Int(((d - Double(s)) / 60).truncatingRemainder(dividingBy: 60))
        let time:String = String(format: "%02d:%02d" ,m,s)
        return time
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
