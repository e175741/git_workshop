//
//  Result_ViewController.swift
//  Screen
//
//  Created by 山城京太郎 on 2018/12/20.
//  Copyright © 2018 Syou Yoshida. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class Result_ViewController: UIViewController, UIPickerViewDelegate, AVAudioPlayerDelegate, MPMediaPickerControllerDelegate{
    
    @IBOutlet weak var perfectNumber: UILabel!
    @IBOutlet weak var greatNumber: UILabel!
    @IBOutlet weak var badNumber: UILabel!
    @IBOutlet weak var missNumber: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "result_haikei.png")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        perfectNumber.text = String(PlayMode.perfectCount)
        greatNumber.text = String(PlayMode.greatCount)
        badNumber.text = String(PlayMode.badCount)
        missNumber.text = String(PlayMode.missCount)
        
    }
}
