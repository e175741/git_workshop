import UIKit

var Fumen: [Double] = []
class ViewController : Play_Music{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タップを定義
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap(sender:)))
        
        // viewにタップを登録
        self.view.addGestureRecognizer(tap)
        
    }
    
    
    /// viewをタップされた時の処理
    @objc func viewTap(sender: UITapGestureRecognizer){
        Append_time()
        print("タップされました")
        
    }
    func Append_time(){
        Fumen.append(super.audioPlayer!.currentTime)
        print(Fumen)
    }
}
