
import UIKit
import SCLAlertView

class ObjectiveFirstTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped () {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, contentViewCornerRadius: 10.0, fieldCornerRadius: 5.0, buttonCornerRadius: 5.0, hideWhenBackgroundViewIsTapped: true)
        
        
        
        
        let alert = SCLAlertView(appearance: appearance)
        
        let txt = alert.addTextView()
        alert.addButton("Done") {
            self.titleLabel.text = txt.text
            self.titleLabel.textColor = UIColor.black
            self.titleLabel.font = UIFont.systemFont(ofSize: 20.0)
        }
        alert.addButton("キャンセル") {
            print("キャンセル")
        }
        alert.showEdit("目標", subTitle: "テキストを入力してください.", colorStyle: 0x50D8FF)
        
    }
}
