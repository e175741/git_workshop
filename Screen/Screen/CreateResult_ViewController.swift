//
//  CreateResult_ViewController.swift
//  Screen
//
//  Created by 山城京太郎 on 2019/02/12.
//  Copyright © 2019 Syou Yoshida. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class CreateResult_ViewController: UIViewController, UIPickerViewDelegate, AVAudioPlayerDelegate, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var createTune: UILabel!
    @IBOutlet weak var noteNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "result_haikei.png")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        createTune.text = select_ViewController.selectTune
        noteNumber.text = String(CreateMode.noteCount)
        
    }
}
