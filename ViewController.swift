import UIKit

var Fumen: [Double] = [] //計測時間の配列
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
        print("タップされました") //テスト用の表示
        
    }
    func Append_time(){
        Fumen.append(super.audioPlayer!.currentTime) //フィールド変数(配列)に計測時間を追加
        print(Fumen) //テスト用の表示
    }
}
