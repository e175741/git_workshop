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
        
        createTune.text = select_ViewController.selectTune
        noteNumber.text = String(CreateMode.noteCount)
        
    }
}
