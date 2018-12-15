//
//  ViewController.swift
//  Screen
//
//

import UIKit
import AVFoundation
import MediaPlayer

// MASAKI
class ViewController: UIViewController,UIPickerViewDelegate,
    AVAudioPlayerDelegate,
    MPMediaPickerControllerDelegate{
    
    var audioPlayer : AVAudioPlayer!
    var timer = Timer()
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    //MASAYA
    var Fumen: [Double] = []
    var num = 0
    var l1 = [5.0,10.0,15.0,20.0,25.0,30.0]
    
    @IBOutlet weak var cTime: UILabel!
    @IBOutlet weak var duaration: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var statemusic: UILabel!
    @IBOutlet weak var create: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    //mainmenu
        
    //PLAY
        
        
        
        // タップを定義
        //let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap(sender:)))
        
        // viewにタップを登録
        //self.view.addGestureRecognizer(tap)
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "sample", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
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
        
        
        //currentTimeを0.5秒ごとに実行
        //timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:#selector(self.CurrentTime), userInfo: nil, repeats: true)
        //progressViewを0.001秒ごとに実行
        //timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector:#selector(self.progressView), userInfo: nil, repeats: true)
        
        
    }//viewDidLoad
    
    
    

    
    
   
    
    
    
    
    func note(begintime:Double){
        UIView.animate(withDuration: 1.0, delay: begintime, animations: {
            
            let view2 = UIView(frame: CGRect(x:100,y:100,width:300,height:100))
            
            view2.backgroundColor = UIColor.black
            self.view.addSubview(view2)
            
            view2.center.y += 800.0
            // animationViewを上に100だけ移動させます。
        }, completion: nil)
    }
    
    // ボタンがタップされた時の処理
    @IBAction func CREATE_PLAY(_ sender: Any) {
        for i in l1
        {
            note(begintime: i-1.0)
        }
        audioPlayer.play()
        //play.setTitle("Stop", for: UIControl.State())
        statemusic.text = "playing"
        
        duaration.text = formatTimeString(d: audioPlayer.duration)

        
        play.isHidden = true
    }
    
    @IBOutlet weak var musi: UIButton!
    
    @IBAction func buttonTappd(_ sender : AnyObject) {
        
        for i in l1
        {
            note(begintime: i-1.0)
        }
        audioPlayer.play()
        //play.setTitle("Stop", for: UIControl.State())
        //statemusic.text = "playing"
        
        musi.isHidden = true
        
    }
    
    @IBAction func buttonTapped(_ sender : AnyObject) {
        
            for i in l1
            {
                note(begintime: i-1.0)
            }
            audioPlayer.play()
            //play.setTitle("Stop", for: UIControl.State())
            //statemusic.text = "playing"
        
        play.isHidden = true
    
    }
  
    
   
    
    @objc func progressView(){
        let currentTime = audioPlayer.currentTime / audioPlayer.duration
        progress.setProgress(Float(currentTime),animated: true)
    }
 
    
    
    
    
    @IBAction func play_music() {
        //progressView()
        CurrentTime()
        audioPlayer.play()
        musi.isHidden = true
        
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
 
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //終了するとendを出力
        //statemusic.text = "end"
        self.performSegue(withIdentifier: "ToResult", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    @objc func viewTap(sender: UITapGestureRecognizer){
        Append_time()
        
        print("タップされました")
        
        //処理はここに
        
        //let difTime.text = String(audioPlayer.currentTime - l1[num])
        
        let hairetu = l1.count - 1
        
        if (num < hairetu)
        {
            
            let dif: Double = audioPlayer.currentTime - l1[num]
            
            
            if (-0.1 <= dif && dif <= 0.1){
                //Decision.text = "perfect"
                num += 1
                
            }else if((-0.5 <= dif && dif < 0.1) || (0.1 < dif && dif <= 0.5)){
                //Decision.text = "great"
                num += 1
             
            }else if( (-1.0 < dif && dif < -0.5) || (0.5 < dif  && dif < 1.0)){
                //Decision.text = "bad"
                num += 1

            }
        }
    }


    // viewをタップされた時の処理
    //@objc func viewTap(sender: UITapGestureRecognizer){
        //Append_time()
    //}
    func Append_time(){
        Fumen.append(audioPlayer!.currentTime)
        print(Fumen)
    }

}//class viewcontroller

