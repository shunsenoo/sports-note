

import UIKit
import RealmSwift

class AddObjectiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    
    var selectedDate: Date!
    
    
    var sectionName: [String] = ["目標種別","タイトル","詳細","達成期限"]
    var contentShow: [String:[String]] = ["目標種別":[],"タイトル":[],"詳細":[],"達成期限":[]]

    override func viewDidLoad() {
        super.viewDidLoad()

       
        tableView.register(UINib(nibName: "ObjectiveFirstTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomCell1")
        tableView.register(UINib(nibName: "ObjectiveZeroTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomCell0")
        tableView.register(UINib(nibName: "ObjectiveSecondTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomCell2")
        // Do any additional setup after loading thre view.
        
        //taleview上の余計な線を消す
        self.tableView.tableFooterView = UIView()
        
        //セルの高さを決める
        self.tableView.estimatedRowHeight = 55.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell0 = tableView.dequeueReusableCell(withIdentifier: "CustomCell0")as! ObjectiveZeroTableViewCell
            return cell0
        case 1:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "CustomCell1")as! ObjectiveFirstTableViewCell
            
            cell1.titleLabel.text = "タイトルを記入してください"
            cell1.titleLabel.textColor = UIColor.darkGray
            cell1.titleLabel.font = UIFont.systemFont(ofSize: 17.0)
     
            return cell1
        case 2:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "CustomCell1")as! ObjectiveFirstTableViewCell
            cell1.titleLabel.text = "詳細を記入してください\n\n"
            cell1.titleLabel.textColor = UIColor.darkGray
            cell1.titleLabel.font = UIFont.systemFont(ofSize: 17.0)
            return cell1
        case 3:
            let cell0 = tableView.dequeueReusableCell(withIdentifier: "CustomCell0")as! ObjectiveZeroTableViewCell
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "CustomCell2")as! ObjectiveSecondTableViewCell
            switch cell0.segmentedControl.selectedSegmentIndex {
            case 0:
                // HomeVCから受け継いだ選択された日にち（date型）を書式と場所を設定してString型で代入
                let dateformatter = DateFormatter()
                dateformatter.locale = Locale(identifier: "ja_JP")
                dateformatter.dateStyle = .long
                let calendar = Calendar.current
                let date = calendar.date(byAdding: .day, value: 14, to: calendar.startOfDay(for: selectedDate))
                cell2.timeTextField.text = dateformatter.string(from: date!)
                return cell2
            case 1:
                // HomeVCから受け継いだ選択された日にち（date型）を書式と場所を設定してString型で代入
                let dateformatter = DateFormatter()
                dateformatter.locale = Locale(identifier: "ja_JP")
                dateformatter.dateStyle = .long
                let calendar = Calendar.current
                let date = calendar.date(byAdding: .month , value: 1 , to: calendar.startOfDay(for: selectedDate))
                cell2.timeTextField.text = dateformatter.string(from: date!)
                return cell2
            case 2:
                // HomeVCから受け継いだ選択された日にち（date型）を書式と場所を設定してString型で代入
                let dateformatter = DateFormatter()
                dateformatter.locale = Locale(identifier: "ja_JP")
                dateformatter.dateStyle = .long
                let calendar = Calendar.current
                let date = calendar.date(byAdding: .month, value: 3, to: calendar.startOfDay(for: selectedDate))
                cell2.timeTextField.text = dateformatter.string(from: date!)
                return cell2
            default :
                // HomeVCから受け継いだ選択された日にち（date型）を書式と場所を設定してString型で代入
                let dateformatter = DateFormatter()
                dateformatter.locale = Locale(identifier: "ja_JP")
                dateformatter.dateStyle = .long
                _ = Calendar.current
                cell2.timeTextField.text = dateformatter.string(from: selectedDate!)
                return cell2
            }
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell1")as! ObjectiveFirstTableViewCell
            return cell
        }
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    // 登録ボタンでRealmに保存
    @IBAction func saveBtnPushed(sender: UIButton){
    // マイグレーション処理
        let config = Realm.Configuration(schemaVersion: 2)
        do{
                // realm を初期化
                let realm = try! Realm(configuration: config)
                // 保存する要素を書く
                let objective = Objective()
                objective.id = self.newId(model: objective)!
                let cell0 = tableView.dequeueReusableCell(withIdentifier: "CustomCell0")as! ObjectiveZeroTableViewCell
                objective.duration = cell0.duration
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "CustomCell1")as! ObjectiveFirstTableViewCell
                objective.title = cell1.titleLabel.text!
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "CustomCell2")as! ObjectiveSecondTableViewCell
            objective.deadlineDate = cell2.timeTextField.text!
                //Realmに書き込み
                try! realm.write {
                    realm.add(objective, update: true)
                    print("データ書き込み中")
                }
            }
    }
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
    
}


