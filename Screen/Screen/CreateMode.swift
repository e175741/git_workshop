//
//  CreateMode.swift
//  Screen
//
//  Created by Soto on 2018/12/16.
//  Copyright © 2018 Syou Yoshida. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class CreateMode: UIViewController, UIPickerViewDelegate, AVAudioPlayerDelegate, MPMediaPickerControllerDelegate{
    
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet weak var StartButton: UIButton!
    
    //セーブデータ
    let userDefaults = UserDefaults.standard
    
    var timer = Timer() // タイマー
    var Fumen_num = 0 //現在の譜面の位置を記録
    
    var Fumen: [Double] = [] //ここに譜面データを読み込む
    var l1 = [5.0,10.0,15.0,20.0,25.0,30.0] //仮の譜面
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "sample", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap(sender:)))
        self.view.addGestureRecognizer(tap) // viewにタップを登録
        
        // audio を再生するプレイヤーを作成する
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
        
        audioPlayer.delegate = self//この子消すとplay終了後result画面に飛ばない
        audioPlayer.prepareToPlay()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:#selector(self.CurrentTime), userInfo: nil, repeats: true)
        
    } //end of viewDidLoad()
    
    
    // startボタンが押された時
    @IBAction func buttonTappd(_ sender : AnyObject) {
        audioPlayer.play() // 音楽を再生
        StartButton.isHidden = true //ボタンを隠す
        
    }
    
    // 画面がタップされた時の処理
    @objc func viewTap(sender: UITapGestureRecognizer){
        Fumen.append(audioPlayer!.currentTime)
        
        print("butun tapped")
        
    }
    
    // missの判定
    @objc func CurrentTime(){
        //現在の再生時間
        
        if(Fumen_num < l1.count){
            
            let dif: Double = audioPlayer.currentTime - l1[Fumen_num]
            if (dif > 1){
                //Decision.text = "miss"
                Fumen_num += 1
            }}
    }
    
    //終了するとendを出力
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Keyを指定して保存
        userDefaults.set(Fumen, forKey: "sample")
        userDefaults.synchronize()
        
        self.performSegue(withIdentifier: "ToResult", sender: nil)
    }
    
}
