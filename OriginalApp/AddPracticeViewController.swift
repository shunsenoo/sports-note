

import UIKit
import RealmSwift
import AVKit
import AVFoundation

class AddPracticeViewController: UIViewController, UIToolbarDelegate, UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var conditionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weatherSegmentedControl: UISegmentedControl!
    @IBOutlet weak var practiceMenuTableView: UITableView!
    @IBOutlet weak var objectiveTextField: UITextField!
    @IBOutlet weak var achievementLabel: UILabel!
    @IBOutlet weak var goodsTextView: UITextView!
    @IBOutlet weak var badsTextView: UITextView!
    @IBOutlet weak var tipsTextView: UITextView!
    // @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
   
    
    // UItoolvarの使用を宣言
    var toolbar: UIToolbar!
    // メニューのtableViewに使う変数の宣言
    var practiceToShow:[String:[String]] = ["打撃":[],"守備":[],"走塁":[],"投球":[],"総合実践":[]]
    var practiceCategories:[String] = ["打撃","守備","走塁","投球","総合実践"]
    var timeToShow:[String:[String]] = ["打撃":[],"守備":[],"走塁":[],"投球":[],"総合実践":[]]
    
    // カレンダーで押された日時を引き継ぐ
    var selectedDate: Date!
    
    var condition = ""
    var weather = ""
    
    var videoURL: URL?
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        practiceMenuTableView.delegate = self
        practiceMenuTableView.dataSource = self
        placeTextField.delegate = self
        objectiveTextField.delegate = self
        scrollView.delegate = self
        goodsTextView.delegate = self
        badsTextView.delegate = self
        tipsTextView.delegate = self
    
        // datepicker上のtoolbarのdoneボタン
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddPracticeViewController.doneBtn))
        
        toolbar.items = [doneBtn]
        dateTextField.inputAccessoryView = toolbar
        startTimeTextField.inputAccessoryView = toolbar
        endTimeTextField.inputAccessoryView = toolbar
        goodsTextView.inputAccessoryView = toolbar
        badsTextView.inputAccessoryView = toolbar
        tipsTextView.inputAccessoryView = toolbar
        objectiveTextField.inputAccessoryView = toolbar
        placeTextField.inputAccessoryView = toolbar
        
        // HomeVCから受け継いだ選択された日にち（date型）を書式と場所を設定してString型で代入
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ja_JP")
        dateformatter.dateFormat = "yyyy年MM月dd日"
        dateTextField.text = dateformatter.string(from: selectedDate!)
        
        // 達成度の数字の表示からーをグレイにする
        achievementLabel.textColor = UIColor.lightGray
        
        // セルの登録
        let nib = UINib(nibName: "MenuTableViewCell", bundle: Bundle.main)
        practiceMenuTableView.register(nib, forCellReuseIdentifier: "MenuCell")
        
        // segmentedControllがタップされたら関数が呼ばれる
        conditionSegmentedControl.addTarget(self, action: #selector(conditionSegmentedControl(sender:)), for: UIControlEvents.allEvents)
        weatherSegmentedControl.addTarget(self, action: #selector(weatherSegmentControl(sender:)), for: UIControlEvents.allEvents)
        // imageViewの初期画像を設定
        imageView.image = UIImage(named: "image_placeholder.png")
        
        practiceMenuTableView.separatorColor = UIColor.darkGray
        // cell間の線を左端まで伸ばす
        practiceMenuTableView.separatorInset = .zero
        
    }
    // 画面が表示された時にnotificationにキーボードの動きを監視させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.practiceMenuTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(AddPracticeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddPracticeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        let info = notification.userInfo
        let keyboardFrame = (info![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // bottom of textField
        let bottomTextField = objectiveTextField.frame.origin.y + placeTextField.frame.height
        let topKeyboard = UIScreen.main.bounds.height - keyboardFrame.size.height
        let distance1 = bottomTextField - topKeyboard
        if distance1 >= 0  {
            // scrollViewのコンテツを上へオフセット + 20.0(追加のオフセット)
            scrollView.contentOffset.y = distance1 + 20.0
        }
        let bottomGoodsTextView = goodsTextView.frame.origin.y + goodsTextView.frame.height
        let distance2 = bottomGoodsTextView - topKeyboard
        if distance2 >= 0 {
            scrollView.contentOffset.y  = distance2
        }
        let bottomBadsTextView = badsTextView.frame.origin.y + badsTextView.frame.height
        let distance3 = bottomBadsTextView - topKeyboard
        if distance3 >= 0 {
            scrollView.contentOffset.y = distance3
        }
        let bottomTipsTextView = tipsTextView.frame.origin.y + tipsTextView.frame.height
        let distance4 = bottomTipsTextView - topKeyboard
        if distance4 >= 0 {
            scrollView.contentOffset.y = distance4
        }
        
    }
    @objc func keyboardWillHide(_ notification: Notification){
        scrollView.contentOffset.y = 0
    }
    // 以下tableView の設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return practiceCategories.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if practiceToShow[practiceCategories[section]]! == [] {
            return ""
        } else {
            return practiceCategories[section]
        }
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if practiceToShow[practiceCategories[indexPath.section]]! == [] {
            cell.isHidden = true
        }
    }

    // practiceToShowにカテゴリー（practiceToShowのキーとなっている）ごとのnameが格納されている
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return practiceToShow[practiceCategories[section]]!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableViewCell
        
        let sectionData = practiceToShow[practiceCategories[indexPath.section]]
        let sectionTime = timeToShow[practiceCategories[indexPath.section]]
        let cellData = sectionData?[indexPath.row]
        let cellTime = sectionTime?[indexPath.row]
        
        cell.menuLabel?.text = "\(cellData!)"
        cell.timeLabel.text = "\(cellTime!)"

        
        
        return cell
    }
    
    

    // キャンセルを押したらホームに戻る
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // 登録ボタンでRealmに保存
    @IBAction func saveBtnPushed(sender: UIButton){
        // 時間が記入されないで登録を押すとアラートを出す
        if  startTimeTextField.text! != "" && endTimeTextField.text! != ""{
            print("データ書き込み開始")
            // マイグレーション処理
            let config = Realm.Configuration(schemaVersion: 2)
            do{
                // realm を初期化
                let realm = try! Realm(configuration: config)
                // 保存する要素を書く
                let practice = Practice()
                practice.id = self.newId(model: practice)!
                practice.date = dateTextField.text!
                practice.place = placeTextField.text!
                practice.startTime = startTimeTextField.text!
                practice.endTime = endTimeTextField.text!
                practice.weather = weather
                practice.condition = condition
                practice.objective = objectiveTextField.text!
                practice.achievement = achievementLabel.text!
                practice.goods = goodsTextView.text!
                practice.bads = badsTextView.text!
                practice.tips = tipsTextView.text!
                // practice.content = contentTextView.text!
                practice.tips = tipsTextView.text!

                //Realmに書き込み
                try! realm.write {
                    realm.add(practice, update: true)
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

    @IBAction func conditionSegmentedControl(sender: UISegmentedControl){
        // セグメント番号で条件分岐させる
        switch sender.selectedSegmentIndex {
        case 0:
            condition = "疲労"
        case 1:
            condition = "普通"
        case 2:
            condition = "元気"
        default:
            print("該当なし")
        }
    }
    @IBAction func weatherSegmentControl(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            weather = "雨"
        case 1:
            weather = "曇り"
        case 2:
            weather = "晴れ"
        default:
            print("該当なし")
        }
    }
    @IBAction func achievementSlider(sender: UISlider){
        let level = sender.value
        let ilevel = Int(level)
        achievementLabel.text = "\(ilevel)%"
    }
    @IBAction func selectImage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            pickerView.mediaTypes = ["public.movie"]
            self.present(pickerView ,animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        videoURL = info["UIImagePickerControllerReferenceURL"] as? URL
        print(videoURL!)
        imageView.image = previewImageFromVideo(videoURL!)!
        imageView.contentMode = .scaleAspectFit
        self.dismiss(animated: true, completion: nil)
        /*// 選択した画像を表示
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        // カメラロールのビューを消す
        self.dismiss(animated: true, completion: nil)*/
    }
    func previewImageFromVideo(_ url:URL) -> UIImage? {
        print("動画からサムネイルを生成する")
        let asset = AVAsset(url:url)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = min(time.value,2)
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return UIImage(named: "image_placeholder.png")
        }
    }
    //動画再生
    @IBAction func playMovie(_ sender: Any) {
        
        if let videoURL = videoURL{
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true){
                print(videoURL)
                print("動画再生")
                playerViewController.player!.play()
            }
        }
    }
    // textFieldを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        placeTextField.resignFirstResponder()
        objectiveTextField.resignFirstResponder()
        return true
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
        goodsTextView.resignFirstResponder()
        badsTextView.resignFirstResponder()
        tipsTextView.resignFirstResponder()
        placeTextField.resignFirstResponder()
        objectiveTextField.resignFirstResponder()
    }
    
    /* var number = 0
    
    for ev in result{
    let textview = UITextView(frame: CGRect(x: 16, y: 520 + 30 * number, width: Int(self.view.bounds.width), height: 30))
    textview.isEditable = false
    textview.isSelectable = false
    textview.text = "\(ev.startTime) ー \(ev.endTime) @\(ev.place)"
    self.view.addSubview(textview)
    number = number + 1
    }*/
}
