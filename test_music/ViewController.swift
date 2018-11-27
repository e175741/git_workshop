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
    var nekoneko:AVAudioPlayer!
    var nekoneko2:AVAudioPlayer!
    var nekoneko3:AVAudioPlayer!
    var nekoneko4:AVAudioPlayer!
    var audioPlayer:AVAudioPlayer!
    var timer = Timer()
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    var l1 = [5.0,10.0,15.0,20.0,25.0,30.0]
    var num = 0
    
    @IBOutlet weak var cTime: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var play: UIButton!
    
    @IBOutlet weak var difTime: UILabel!
    @IBOutlet weak var Decision: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "sample2", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        let neko1 = Bundle.main.path(forResource: "cat_like1a",ofType:"mp3")!
        let catUrl = URL(fileURLWithPath: neko1)
        
        let neko2 = Bundle.main.path(forResource: "cat_like2a",ofType:"mp3")!
        let catUrl2 = URL(fileURLWithPath: neko2)
        
        let neko3 = Bundle.main.path(forResource: "cat_like3a",ofType:"mp3")!
        let catUrl3 = URL(fileURLWithPath: neko3)
        
        let neko4 = Bundle.main.path(forResource: "cat_like4a",ofType:"mp3")!
        let catUrl4 = URL(fileURLWithPath: neko4)
        
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            nekoneko = try AVAudioPlayer(contentsOf: catUrl)
            nekoneko2 = try AVAudioPlayer(contentsOf: catUrl2)
            nekoneko3 = try AVAudioPlayer(contentsOf: catUrl3)
            nekoneko4 = try AVAudioPlayer(contentsOf: catUrl4)
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
        
        //判定線
        let view1 = UIView(frame: CGRect(x:100,y:900,width:1000,height:10))
        view1.backgroundColor = UIColor.black
        self.view.addSubview(view1)
        
        
        
    }
    
    
    func readingTextFile(fileName: String) -> String{
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")!
        
        if let data = NSData(contentsOfFile: path){
            let TextData: String = String(NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!)
            print(TextData)
            return TextData
        }else{
            print("データなし")
            return "データなし"
        }
    }
    
    //ファイルの書き込み関数
    func createTextFromString(aString: String, saveToDocumentsWithFileName fileName: String) {
        
        let writeText: String = readingTextFile(fileName: fileName) + "\n" + aString
        
        // 書き込むファイルのパス
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")!
        
        do {
            try writeText.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        } catch _ as NSError {
            print("failed to write: (error)")
        }
    }
    
    @IBAction func getTime(_ sender : AnyObject) {
        difTime.text = String(audioPlayer.currentTime - l1[num])
        
        let hairetu = l1.count - 1
        
        if (num < hairetu)
        {
        
        let dif: Double = audioPlayer.currentTime - l1[num]
        
        
        if (-0.1 <= dif && dif <= 0.1){
            Decision.text = "perfect"
            num += 1
            nekoneko4.play()
            
            }else if((-0.5 <= dif && dif < 0.1) || (0.1 < dif && dif <= 0.5)){
            Decision.text = "great"
            num += 1
            nekoneko3.play()
        }else if( (-1.0 < dif && dif < -0.5) || (0.5 < dif  && dif < 1.0)){
            Decision.text = "bad"
            num += 1
            nekoneko2.play()
        } else{
            nekoneko.play()
            }
        }
        
    }
    
    
    // ボタンがタップされた時の処理
    @IBAction func buttonTapped(_ sender : AnyObject) {
        if ( audioPlayer.isPlaying ){
            audioPlayer.stop()
            play.setTitle("Play", for: UIControl.State())
            
            readingTextFile(fileName: "hoge")
        }
            
        else{
            audioPlayer.play()
            play.setTitle("Stop", for: UIControl.State())
            
            createTextFromString(aString:"test", saveToDocumentsWithFileName : "hoge")
        }
        
        for i in l1
        {
        note(begintime: i-1.0)
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
        
        let hairetu = l1.count - 1
        
        if(num < hairetu){
        
        let dif: Double = audioPlayer.currentTime - l1[num]
        if (dif > 1){
            Decision.text = "miss"
            num += 1
            }}
    }
    
    
    func formatTimeString(d: Double) -> String{
        //TimeIntervalからStringへ変換,00:00の形式に直す
        let s:Int = Int(d.truncatingRemainder(dividingBy: 60))
        let m:Int = Int(((d - Double(s)) / 60).truncatingRemainder(dividingBy: 60))
        let time:String = String(format: "%02d:%02d" ,m,s)
        return time
    }
    
    func note(begintime:Double){
        UIView.animate(withDuration: 1.0, delay: begintime, animations: {
            
            let view2 = UIView(frame: CGRect(x:100,y:100,width:300,height:100))
            
            view2.backgroundColor = UIColor.black
            self.view.addSubview(view2)
            
            view2.center.y += 800.0    // animationViewを上に100だけ移動させます。
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
