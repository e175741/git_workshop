//
//  MENU_ViewController.swift
//  Screen
//
//  Created by Syou Yoshida on 2018/12/07.
//  Copyright © 2018 Syou Yoshida. All rights reserved.
//

import UIKit

class MENU_ViewController: UIViewController {
    
    
    @IBOutlet weak var game_title: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game_title.textColor = UIColor.init(red: 255/255, green: 153/255, blue: 0/255, alpha: 90/100)
        game_title.shadowColor = UIColor.white
        
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "menu_haikei.png")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
