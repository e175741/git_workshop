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
    var audioPlayer3 : AVAudioPlayer!
    var audioPlayer4 : AVAudioPlayer!
    

    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var Decision: UILabel!
    
    static var perfectCount = 0
    static var greatCount = 0
    static var badCount = 0
    static var missCount = 0
    
    // セーブデータ
    let userDefaults = UserDefaults.standard
    
    var timer = Timer() // タイマー
    var Fumen_num:[Int] = [0,0,0,0] //現在の譜面の位置を記録
    
    var Fumen: [[Double]] = [[],[],[],[]] //ここに譜面データを読み込む
    var l1 = [3.0,7.0,8.0,15.0,23.0,27.0,28.0,29.0,31.0] //仮の譜面
    var l2 = [5.0,10.0,15.0,20.0,25.0,29.0]
    var l3 = [6.0,12.0,17.0,20.0,25.0,26.0]
    var l4 = [3.0,8.0,15.0,16.0,19.0,23.0,25.0,30.0]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Decision.textColor = UIColor.white
        
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
        
        let audioPath2 = Bundle.main.path(forResource: "perfect_sound", ofType:"mp3")!
        let audioUrl2 = URL(fileURLWithPath: audioPath2)
        
        let audioPath3 = Bundle.main.path(forResource: "good_sound", ofType:"mp3")!
        let audioUrl3 = URL(fileURLWithPath: audioPath3)
        
        let audioPath4 = Bundle.main.path(forResource: "bad_sound", ofType:"mp3")!
        let audioUrl4 = URL(fileURLWithPath: audioPath4)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap(sender:)))
        self.view.addGestureRecognizer(tap) // viewにタップを登録
        
        
        let default_Fumen: [[Double]] = [l1,l2,l3,l4] //デフォルト譜面
        
        userDefaults.register(defaults: ["sample": default_Fumen])
        
        //譜面読み込み
        Fumen = userDefaults.object(forKey: "sample") as! [[Double]]
        //Fumen = default_Fumen
        
        for i in 1...3 {
            //Fumen_num[i] = Fumen_num[i-1] + Fumen[i].count
            Fumen_num[i] = Fumen_num[i-1] + Fumen[i-1].count
            
        }
        
        
        // audio を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            audioPlayer2 = try AVAudioPlayer(contentsOf: audioUrl2)
            audioPlayer3 = try AVAudioPlayer(contentsOf: audioUrl3)
            audioPlayer4 = try AVAudioPlayer(contentsOf: audioUrl4)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
            audioPlayer2 = nil
            audioPlayer3 = nil
            audioPlayer4 = nil
        }
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer2.volume = 5.0
        audioPlayer3.volume = 4.0
        audioPlayer4.volume = 10.0
        
        audioPlayer.delegate = self//この子消すとplay終了後result画面に飛ばない
        audioPlayer.prepareToPlay()

        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:#selector(self.miss_judge), userInfo: nil, repeats: true)
        
    } //end of viewDidLoad()
    
    
    // startボタンが押された時
    @IBAction func buttonTappd(_ sender : AnyObject) {
        
        var list_num:Double=0
        var tag_num:Int = 0
        
        for i in Fumen{
            for j in i{
                tag_num += 1
                note(len: list_num, begintime: j-1.0, tag: tag_num)
            }
            list_num+=1
        }
        
        judgeLine() //判定線を生成
        audioPlayer.play() // 音楽を再生
        StartButton.isHidden = true //ボタンを隠す
        
    }
    
    // 画面がタップされた時の処理
    @objc func viewTap(sender: UITapGestureRecognizer){
        
        let xypoint = sender.location(in: self.view)
        
        let width = Double( UIScreen.main.bounds.size.width);
        
        switch Double(xypoint.x){
        case 0.0...width/4:
            judge(len:0,count:0)
        case 0.0...width/2:
            judge(len:1,count:Fumen[0].count)
        case 0.0...3*width/4:
            judge(len:2,count:Fumen[0].count+Fumen[1].count)
        case 0.0...width:
            judge(len:3,count:Fumen[0].count+Fumen[1].count+Fumen[2].count)
        default:
            print("その他")
        }
        
    }
    
    
    func judge(len:Int,count:Int){
        if (Fumen_num[len] < count+Fumen[len].count){
            let dif: Double = audioPlayer.currentTime - Fumen[len][Fumen_num[len]-count]
            if (-0.1 <= dif && dif <= 0.1){
                Decision.text = "perfect"
                Fumen_num[len] += 1
                PlayMode.perfectCount += 1
                audioPlayer2.play()
                self.view.subviews.forEach {
                    if $0.tag == Fumen_num[len]{
                        $0.removeFromSuperview()
                    }
                }
            }else if((-0.5 <= dif && dif < 0.1) || (0.1 < dif && dif <= 0.5)){
                Decision.text = "great"
                Fumen_num[len] += 1
                print(dif)
                PlayMode.greatCount += 1
                audioPlayer3.play()
                self.view.subviews.forEach {
                    if $0.tag == Fumen_num[len]{
                        $0.removeFromSuperview()
                    }
                }
            }else if( (-1.0 < dif && dif < -0.5) || (0.5 < dif  && dif < 1.0)){
                Decision.text = "bad"
                Fumen_num[len] += 1
                print(dif)
                PlayMode.badCount += 1
                audioPlayer4.play()
                self.view.subviews.forEach {
                    if $0.tag == Fumen_num[len]{
                        $0.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    // missの判定
    @objc func miss_judge(){
        
        missnote(len: 1, count:Fumen[0].count)
        missnote(len: 2, count:Fumen[0].count+Fumen[1].count)
        missnote(len: 3, count:Fumen[0].count+Fumen[1].count+Fumen[2].count)
        missnote(len: 0, count:0)
        
    }
    
    
    func missnote(len:Int,count:Int){
        if (Fumen_num[len] < count+Fumen[len].count){
            let dif: Double = audioPlayer.currentTime - Fumen[len][Fumen_num[len]-count]
            if (dif > 1){
                Decision.text = "miss"
                Fumen_num[len] = Fumen_num[len]+1
                PlayMode.missCount += 1
                print("ミス",Fumen_num[len],count,dif)
                self.view.subviews.forEach {
                    if $0.tag == Fumen_num[len]{
                        $0.removeFromSuperview()
                    }
                }
            }
        }
        
    }
    
    
    func judgeLine(){
        //let judgeLineView = UIView(frame: CGRect(origin: CGPoint(x:0, y:view.bounds.height - 300), size: CGSize(width: view.bounds.width, height: 100)))
        // 透明な赤色のラインにする
        //judgeLineView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        // 判定ラインを表示
        let line_img = UIImageView()
        line_img.frame = CGRect(x: 0, y: view.bounds.height - 300, width: view.bounds.width , height: 100)
        let image = UIImage(named:"judgeLine.png")!
        line_img.image = image
        
        view.addSubview(line_img)
    }
    
    // ノーツが落ちてくる関数
    func note(len:Double,begintime:Double,tag:Int){
        
        let width = Double( UIScreen.main.bounds.size.width) / 4; //画面の４分の１
        //ノーツの画像読み込み
        let note_img = UIImageView()
        note_img.frame = CGRect(x: width*(len), y: -100, width: width , height: 100)
        
        let image = UIImage(named:"note.png")!
        note_img.image = image
        
        //アニメーション
        UIView.animate(withDuration: 1.21645022, delay: begintime,options: .curveLinear,
            animations: {

            self.view.addSubview(note_img)
            note_img.tag = tag
            note_img.center.y += 1124.0
                
        }, completion: nil)
        
    }
    
    //終了するとendを出力
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.performSegue(withIdentifier: "ToResult", sender: nil)
    }

}
