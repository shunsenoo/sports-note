
import UIKit

class AddPracticeMenuViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var practiceMenuTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    var practiceCategory: String!
    // ①
    var toolBar: UIToolbar!
    
    let hours: [Int] = ([Int])(0...4)
    let minutes: [Int] = ([Int])(0...29).map{$0 * 5}
    let pickerView = UIPickerView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        categorySegmentedControl.addTarget(self, action: #selector(self.categoryChosen(_:)), for: UIControlEvents.allEvents)
        
        
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        toolBar.setItems([doneItem, cancelItem], animated: true)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        pickerView.backgroundColor = UIColor.white
        timeTextField.inputView = pickerView
        timeTextField.inputAccessoryView = toolBar
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        } else if component == 1{
            return minutes.count
        } else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(hours[row])時間"
        } else if component == 1{
            return "\(minutes[row])分"
        } else {
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hour = hours[pickerView.selectedRow(inComponent: 0)]
        let minute = minutes[pickerView.selectedRow(inComponent: 1)]
        if hour == 0 {
            timeTextField.text = "\(minute)分"
        } else {
            timeTextField.text = "\(hour)時間\(minute)分"
        }
        
    }
    @objc func done() {
        self.timeTextField.endEditing(true)
    }
    @objc func cancel() {
        self.timeTextField.text = ""
        self.timeTextField.endEditing(true)
    }
   
    
    //toolbarのdoneボタン
    @objc func doneBtn(){
        timeTextField.resignFirstResponder()
    }
    
    @objc func categoryChosen(_ sender: UISegmentedControl){
        // choose category of task
        switch sender.selectedSegmentIndex {
        case 0:
            practiceCategory = "打撃"
        case 1:
            practiceCategory = "守備"
        case 2:
            practiceCategory = "走塁"
        case 3:
            practiceCategory = "投球"
        case 4:
            practiceCategory = "総合実践"
        default:
            break
        }
        
    }
    @IBAction func cancelButtonPushed(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addButtonPushed(){
        let practiceMenu = practiceMenuTextField.text
        let practiceTime = timeTextField.text
        if practiceMenu == "" || practiceTime == "" {
            
            self.dismiss(animated: true, completion: nil)
        } else  {
            let nc = self.presentingViewController as! UINavigationController
            let vc = nc.topViewController as! AddPracticeViewController
            vc.practiceToShow[practiceCategory]?.append(practiceMenu!)
            vc.timeToShow[practiceCategory]?.append(practiceTime!)
            
        self.dismiss(animated: true, completion: nil)
        }
    }

}
