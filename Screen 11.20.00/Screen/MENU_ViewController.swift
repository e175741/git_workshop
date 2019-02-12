//
//  MENU_ViewController.swift
//  Screen
//
//  Created by Syou Yoshida on 2018/12/07.
//  Copyright © 2018 Syou Yoshida. All rights reserved.
//

import UIKit

class MENU_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
