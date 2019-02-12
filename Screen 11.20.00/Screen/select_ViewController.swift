//
//  select_ViewController.swift
//  Screen
//
//  Created by Syou Yoshida on 2018/12/07.
//  Copyright © 2018 Syou Yoshida. All rights reserved.
//

import UIKit

class select_ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var selector: UIPickerView!
    @IBOutlet weak var label:
        UILabel!
    
    @IBAction func aaa(_ sender: Any) {
    }
    
    private let music = ["sample1","sample2","hoge"]
    var test:String = "sample1"
    
    static var selectTune:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //select music
        
        // Do any additional setup after loading the view, typically from a nib.
        
        selector.dataSource = self
        selector.delegate = self

        PlayMode.perfectCount = 0
        PlayMode.greatCount = 0
        PlayMode.badCount = 0
        PlayMode.missCount = 0
        
        select_ViewController.selectTune = test
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return music.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return music[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        test = music[row]
        label.text = test
        
        //曲選択~AppDelegate
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate//AppDelegateのインスタンスを取得
        appDelegate.select = music[row] //appDelegateの変数を操作
        
    }
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

