

import UIKit

@IBDesignable

class IBDesignableButton: UIButton {
    
    // 以下の変数宣言でデフォルトの数字になる
    @IBInspectable var borderColor: UIColor = UIColor.blue
    @IBInspectable var borderWidth: CGFloat = 1.0

    // Attribute 上の設定を反映
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    

}
