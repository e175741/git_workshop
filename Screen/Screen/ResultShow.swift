//
//  PlayMode.swift
//  Screen
//
//  Created by Soto on 2018/12/16.
//  Copyright © 2018 Syou Yoshida. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ResultShow: UIViewController, UIPickerViewDelegate, AVAudioPlayerDelegate, MPMediaPickerControllerDelegate{
    
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var Decision: UILabel!
    
    // セーブデータ
    let userDefaults = UserDefaults.standard
    
    var timer = Timer() // タイマー
    var Fumen_num = 0 //現在の譜面の位置を記録
    
    var Fumen: [Double] = [] //ここに譜面データを読み込む
    var l2 = [5.0,10.0,15.0,20.0,25.0,30.0] //仮の譜面
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "sample", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap(sender:)))
        self.view.addGestureRecognizer(tap) // viewにタップを登録
        
        userDefaults.register(defaults: ["sample": l2])
        
        Fumen = userDefaults.object(forKey: "sample") as! [Double]
        
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
        
        for i in Fumen
        {
            note(begintime: i-1.0)
        }
        audioPlayer.play() // 音楽を再生
        StartButton.isHidden = true //ボタンを隠す
        
    }
    
    // 画面がタップされた時の処理
    @objc func viewTap(sender: UITapGestureRecognizer){
        let hairetu = Fumen.count
        
        if (Fumen_num < hairetu){
            let dif: Double = audioPlayer.currentTime - Fumen[Fumen_num]
            
            
            if (-0.1 <= dif && dif <= 0.1){
                Decision.text = "perfect"
                Fumen_num += 1
                print(dif)
                
            }else if((-0.5 <= dif && dif < 0.1) || (0.1 < dif && dif <= 0.5)){
                Decision.text = "great"
                Fumen_num += 1
                print(dif)
                
            }else if( (-1.0 < dif && dif < -0.5) || (0.5 < dif  && dif < 1.0)){
                Decision.text = "bad"
                Fumen_num += 1
                print(dif)
            }
        }
    }
    
    // missの判定
    @objc func CurrentTime(){
        //現在の再生時間
        
        if(Fumen_num < Fumen.count){
            
            let dif: Double = audioPlayer.currentTime - Fumen[Fumen_num]
            if (dif > 1){
                Decision.text = "miss"
                Fumen_num += 1
            }}
    }
    
    // ノーツが落ちてくる関数
    func note(begintime:Double){
        UIView.animate(withDuration: 1.0, delay: begintime, animations: {
            
            let view2 = UIView(frame: CGRect(x:100,y:100,width:300,height:100))
            
            view2.backgroundColor = UIColor.black
            self.view.addSubview(view2)
            
            view2.center.y += 800.0
        }, completion: nil)
    }
    
    //終了するとendを出力
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.performSegue(withIdentifier: "ToResult", sender: nil)
    }
    
}
