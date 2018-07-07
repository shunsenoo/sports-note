import UIKit

class ObjectiveSecondTableViewCell: UITableViewCell,UIPickerViewDelegate,UITextFieldDelegate{
    
    @IBOutlet var timeTextField:UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // datepicker上のtoolbarのdoneボタン
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddPracticeViewController.doneBtn))
        
        toolbar.items = [doneBtn]
        timeTextField.inputAccessoryView =  toolbar
        
        
        timeTextField.delegate = self
        timeTextField.font = UIFont.systemFont(ofSize: 24)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // テキストフィールドが選択されたらdatepickerを表示
    @IBAction func textFieldEditing(sender:UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        // datepicker の設
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action:#selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    // datePickerが選択されたらtextFieldに表示
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy年MM月dd日";
        print(dateFormatter.string(for: sender.date)!)
        timeTextField.text = dateFormatter.string(for: sender.date)
    }
    @objc func doneBtn(){
        timeTextField.resignFirstResponder()
    }
    
}
