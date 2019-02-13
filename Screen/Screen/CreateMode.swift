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
    
    var Fumen1: [Double] = [] //ここに譜面データを読み込む
    var Fumen2: [Double] = []
    var Fumen3: [Double] = []
    var Fumen4: [Double] = []
    
    var l1 = [5.0,10.0,15.0,20.0,25.0,30.0] //仮の譜面
    
    let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    
    static var noteCount = 0
    var noteCount1 = 0
    var noteCount2 = 0
    var noteCount3 = 0
    var noteCount4 = 0
    @IBOutlet weak var Lane1_noteCount: UILabel!
    @IBOutlet weak var Lane2_noteCount: UILabel!
    @IBOutlet weak var Lane3_noteCount: UILabel!
    @IBOutlet weak var Lane4_noteCount: UILabel!
    @IBOutlet weak var lane2: UIButton!
    @IBOutlet weak var lane3: UIButton!
    @IBOutlet weak var lane4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 242/255, green: 216/255, blue: 223/255, alpha: 100/100)
        lane1.backgroundColor = UIColor.init(red: 188/255, green: 200/255, blue: 219/255, alpha: 100/100)
        lane2.backgroundColor = UIColor.init(red: 234/255, green: 245/255, blue: 67/255, alpha: 100/100)
        lane3.backgroundColor = UIColor.init(red: 255/255, green: 195/255, blue: 76/255, alpha: 100/100)
        lane4.backgroundColor = UIColor.init(red: 149/255, green: 255/255, blue: 101/255, alpha: 100/100)
        
        //曲選択~
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate//AppDelegateのインスタンスを取得
        let select = appDelegate.select
        //~曲選択
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: select, ofType:"mp3")!
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
        
        CreateMode.noteCount = 0
        
    }
    
    // 画面がタップされた時の処理
    @objc func viewTap(sender: UITapGestureRecognizer){
        
        let HamonnImage = makeHamonnImage(wigth: 300, height: 300)
        let HamonnView = UIImageView(image: HamonnImage)
        
        HamonnView.transform = scaleTransform
        
        HamonnView.center = sender.location(in: self.view)
        view.addSubview(HamonnView)
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: [ .curveEaseInOut], animations: {HamonnView.alpha = 0.0
            HamonnView.transform = .identity}, completion: nil)
        
    }
    @IBOutlet weak var lane1: UIButton!
    
    
    @IBAction func noteCreate1(_ sender: Any) {
        Fumen1.append(audioPlayer!.currentTime)
        CreateMode.noteCount += 1
        noteCount1 += 1
        Lane1_noteCount.text = String(noteCount1)
    }
    
    
    @IBAction func noteCreate2(_ sender: Any) {
        Fumen2.append(audioPlayer!.currentTime)
        CreateMode.noteCount += 1
        noteCount2 += 1
        Lane2_noteCount.text = String(noteCount2)
    }
    
    @IBAction func noteCreate3(_ sender: Any) {
        Fumen3.append(audioPlayer!.currentTime)
        CreateMode.noteCount += 1
        noteCount3 += 1
        Lane3_noteCount.text = String(noteCount3)
    }
    
    @IBAction func noteCreate4(_ sender: Any) {
        Fumen4.append(audioPlayer!.currentTime)
        CreateMode.noteCount += 1
        noteCount4 += 1
        Lane4_noteCount.text = String(noteCount4)
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
        
        let Fumen_All:[[Double]] = [Fumen1,Fumen2,Fumen3,Fumen4]
        // Keyを指定して保存
        userDefaults.set(Fumen_All, forKey: "sample")
        userDefaults.synchronize()
        
        self.performSegue(withIdentifier: "Result", sender: nil)
    }
    
    func makeHamonnImage(wigth w:CGFloat, height h:CGFloat) -> UIImage {
        let size = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        let ovalRect = CGRect(x: 0, y: 0, width: w, height: h)
        let ovalPath = UIBezierPath(ovalIn: ovalRect)
        context?.setFillColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.0)
        ovalPath.fill()
        ovalPath.lineWidth = 3.0
        context?.setStrokeColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ovalPath.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
