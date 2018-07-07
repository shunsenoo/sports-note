

import UIKit

class ObjectiveZeroTableViewCell: UITableViewCell {
    
    @IBOutlet var segmentedControl:UISegmentedControl!
    @IBOutlet var label:UILabel!
    var duration:Int!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func segmentTapped(sender:UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            duration = 0
            label.text = "短期目標は2週間を目安に設定します。"
        case 1:
            duration = 1
            label.text = "中期目標は1ヶ月を目安に設定します。"
        default:
            duration = 2
            label.text = "長期目標は3ヶ月を目安に設定します。"
        }
    }
    
}
