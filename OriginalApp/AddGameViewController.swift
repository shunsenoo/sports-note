

import UIKit
import RealmSwift

class AddGameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var conditionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weatherSegmentedControl: UISegmentedControl!
    @IBOutlet weak var battingFirstSegmentedController: UISegmentedControl!
    @IBOutlet weak var atBatTextField: UITextField!
    
    @IBOutlet var score1PickerView: UIPickerView!
    @IBOutlet var score2PickerView: UIPickerView!
    @IBOutlet var teamLabel1: UILabel!
    @IBOutlet var teamLabel2: UILabel!
    
    var selectedDate: Date!
    var toolbar: UIToolbar!
    let scorelist:[Int] = ([Int])(0...20)
    var score1 = Int()
    var score2 = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // HomeVCから受け継いだ選択された日にち（date型）を書式と場所を設定してString型で代入
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ja_JP")
        dateformatter.dateFormat = "yyyy年MM月dd日"
        dateTextField.text = dateformatter.string(from: selectedDate!)
        
        // datepicker上のtoolbarのdoneボタン
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddPracticeViewController.doneBtn))
        
        toolbar.items = [doneBtn]
        dateTextField.inputAccessoryView = toolbar
        startTimeTextField.inputAccessoryView = toolbar
        endTimeTextField.inputAccessoryView = toolbar
   
        score1PickerView.delegate = self
        score1PickerView.dataSource = self
        score1PickerView.selectRow(0, inComponent: 0, animated: true)
        score2PickerView.delegate = self
        score2PickerView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func save(){
        // 時間が記入されないで登録を押すとアラートを出す
        if  startTimeTextField.text! != "" && endTimeTextField.text! != ""{
            print("データ書き込み開始")
            // マイグレーション処理
            let config = Realm.Configuration(schemaVersion: 2)
            do{
                // realm を初期化
                let realm = try! Realm(configuration: config)
                // 保存する要素を書く
                let game = Game()
                game.id = self.newId(model: game)!
                game.date = dateTextField.text!
                game.place = placeTextField.text!
                game.startTime = startTimeTextField.text!
                game.endTime = endTimeTextField.text!
                game.teamScore1 = score1
                game.teamScore2 = score2

                /*let practice = Practice()
                practice.id = self.newId(model: practice)!
                practice.date = dateTextField.text!
                practice.place = placeTextField.text!
                practice.startTime = startTimeTextField.text!
                practice.endTime = endTimeTextField.text!*/
               /* practice.weather = weather
                practice.condition = condition
                practice.objective = objectiveTextField.text!
                practice.achievement = achievementLabel.text!
                practice.goods = goodsTextView.text!
                practice.bads = badsTextView.text!
                practice.tips = tipsTextView.text!*/
                // practice.content = contentTextView.text!
                /* practice.tips = tipsTextView.text!*/
                
                //Realmに書き込み
                try! realm.write {
                    realm.add(game, update: true)
                    print("データ書き込み中")
                }
            }
            
            print("データ書き込み完了")
            // 画面遷移
            self.dismiss(animated: true, completion: nil)
        }
            
        else{
            let alert = UIAlertController(title: "時間が空欄です", message: "ノートを追加するには開始時間・終了時間を記入することが必要です。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }        
    }
    //保存の際に新しいIDを発行。
    func newId<T: Object>(model: T) -> Int? {
        let realm = try! Realm()
        
        guard let key = T.primaryKey() else { return nil }
        
        if let last = realm.objects(T.self).last,
            let lastId = last[key] as? Int {
            return lastId + 1
        } else {
            return 0
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scorelist.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(scorelist[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            score1 = scorelist[row]
        } else if pickerView.tag == 2 {
            score2 = scorelist[row]
        }
    }
   
    @IBAction func teamSwitch(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            teamLabel1.text = "自チーム"
            teamLabel2.text = "敵チーム"
        case 1:
            teamLabel1.text = "敵チーム"
            teamLabel2.text = "自チーム"
        default:
            print("該当なし")
        }
    }
    // テキストフィールドが選択されたらdatepickerを表示
    @IBAction func textFieldEditing(sender:UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        // datepicker の設定
        datePickerView.date = selectedDate
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action:#selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    @IBAction func startTimeTextFieldEditing(sender:UITextField) {
        let timePickerView: UIDatePicker = UIDatePicker()
        // datepicker の設定
        timePickerView.backgroundColor = UIColor.white
        timePickerView.datePickerMode = UIDatePickerMode.time
        let cal = Calendar.current
        var dateComps = DateComponents()
        dateComps.hour = 13
        dateComps.minute = 0
        let theTime = cal.date(from: dateComps)
        timePickerView.date = theTime!
        startTimeTextField.text = "13時00分"
        sender.inputView = timePickerView
        timePickerView.addTarget(self, action:#selector(startTimePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    @IBAction func endTimeTextFieldEditing(sender:UITextField) {
        let timePickerView: UIDatePicker = UIDatePicker()
        // datepicker の設定
        timePickerView.backgroundColor = UIColor.white
        timePickerView.datePickerMode = UIDatePickerMode.time
        let cal = Calendar.current
        var dateComps = DateComponents()
        dateComps.hour = 17
        dateComps.minute = 0
        endTimeTextField.text = "17時00分"
        let theTime = cal.date(from: dateComps)
        timePickerView.date = theTime!
        sender.inputView = timePickerView
        timePickerView.addTarget(self, action:#selector(endTimePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    // datePickerが選択されたらtextFieldに表示
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy年MM月dd日";
        print(dateFormatter.string(for: sender.date)!)
        dateTextField.text = dateFormatter.string(for: sender.date)
        
    }
    @objc func startTimePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "HH時mm分";
        startTimeTextField.text = dateFormatter.string(for: sender.date)
        print(dateFormatter.string(for: sender.date)!)
    }
    @objc func endTimePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "HH時mm分";
        endTimeTextField.text = dateFormatter.string(for: sender.date)
    }
    @objc func doneBtn(){
        dateTextField.resignFirstResponder()
        startTimeTextField.resignFirstResponder()
        endTimeTextField.resignFirstResponder()
        placeTextField.resignFirstResponder();
    }
}


