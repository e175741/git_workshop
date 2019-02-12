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

class PlayMode: UIViewController, UIPickerViewDelegate, AVAudioPlayerDelegate, MPMediaPickerControllerDelegate{
    
    var audioPlayer : AVAudioPlayer!
    var audioPlayer2 : AVAudioPlayer!

    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var Decision: UILabel!
    
    static var perfectCount = 0
    static var greatCount = 0
    static var badCount = 0
    static var missCount = 0
    
    // セーブデータ
    let userDefaults = UserDefaults.standard
    
    var timer = Timer() // タイマー
    var Fumen_num = 0 //現在の譜面の位置を記録
    
    var Fumen: [Double] = [] //ここに譜面データを読み込む
    var l2 = [5.0,10.0,15.0,20.0,25.0,30.0] //仮の譜面
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "haikei.png")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        //曲選択~
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate//AppDelegateのインスタンスを取得
        let select = appDelegate.select
        //~曲選択
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: select, ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        //タップ音
        let audioPath2 = Bundle.main.path(forResource: "perfect", ofType:"mp3")!
        let audioUrl2 = URL(fileURLWithPath: audioPath2)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap(sender:)))
        self.view.addGestureRecognizer(tap) // viewにタップを登録
        
        userDefaults.register(defaults: ["sample": l2])
        
        Fumen = userDefaults.object(forKey: "sample") as! [Double]
        
        // audio を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            audioPlayer2 = try AVAudioPlayer(contentsOf: audioUrl2)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
            audioPlayer2 = nil
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
        judgeLine()
        audioPlayer.play() // 音楽を再生
        StartButton.isHidden = true //ボタンを隠す
        
    }
    
    // 画面がタップされた時の処理
    @objc func viewTap(sender: UITapGestureRecognizer){
        let hairetu = Fumen.count
        
        
        
        if (Fumen_num < hairetu){
            let dif: Double = audioPlayer.currentTime - Fumen[Fumen_num]
            
            audioPlayer2.play()
            
            if (-0.1 <= dif && dif <= 0.1){
                Decision.text = "perfect"
                Fumen_num += 1
                PlayMode.perfectCount += 1
                print(dif)
                
            }else if((-0.5 <= dif && dif < 0.1) || (0.1 < dif && dif <= 0.5)){
                Decision.text = "great"
                Fumen_num += 1
                PlayMode.greatCount += 1
                print(dif)
                
            }else if( (-1.0 < dif && dif < -0.5) || (0.5 < dif  && dif < 1.0)){
                Decision.text = "bad"
                Fumen_num += 1
                PlayMode.badCount += 1
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
                PlayMode.missCount += 1
            }}
    }
    
    
    func judgeLine(){
        let judgeLineView = UIView(frame: CGRect(origin: CGPoint(x:0, y:view.bounds.height - 300), size: CGSize(width: view.bounds.width, height: 100)))
        // 透明な赤色のラインにする
        judgeLineView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        // 判定ラインを表示
        view.addSubview(judgeLineView)
    }
    
    // ノーツが落ちてくる関数
    func note(begintime:Double){
        UIView.animate(withDuration: 1.21645022, delay: begintime,options: .curveLinear,
            animations: {
            
            let view2 = UIView(frame: CGRect(x:100,y:-100,width:300,height:100))
            
            view2.backgroundColor = UIColor.white
            self.view.addSubview(view2)
            
            view2.center.y += 1124.0
        }, completion: nil)
    }
    
    //終了するとendを出力
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.performSegue(withIdentifier: "ToResult", sender: nil)
    }

}
