
import UIKit
import FSCalendar
import CalculateCalendarLogic
import SCLAlertView
import RealmSwift


class HomeViewController: UIViewController,FSCalendarDelegate,FSCalendarDelegateAppearance,FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var calender: FSCalendar!
    //@IBOutlet weak var scheduleTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var practiceTableView: UITableView!
    
    var practiceArray: [Practice] = []
    var gameArray: [Game] = []
    var selectingRowData: Practice!
    var selectingDate: Date!
    
    //var array: [Practice] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calender.delegate = self
        self.calender.dataSource = self
        
        self.practiceTableView.delegate = self
        self.practiceTableView.dataSource = self
        
        // dateLabelに今日の日にちを表示
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateLabel.text = dateFormatter.string(from: now)
        selectingDate = now
        
        //taleview上の余計な線を消す
        self.practiceTableView.tableFooterView = UIView()
        
        //セルの高さを決める
        self.practiceTableView.rowHeight = 55.0
        
        // カスタムセルのをセルtabeViewに登録
        let nib1 = UINib(nibName: "PracticeTableViewCell", bundle: Bundle.main)
        practiceTableView.register(nib1, forCellReuseIdentifier: "PracticeCell")
        let nib2 = UINib(nibName: "GameTableViewCell", bundle: Bundle.main)
        practiceTableView.register(nib2, forCellReuseIdentifier: "GameCell")
        
        print(practiceArray)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // グレゴリアン時間
    fileprivate let gregorian : Calendar = Calendar(identifier: .gregorian)
    
    // 一旦formatterを通して日時取得（正しい時間を取得）
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする
        if self.judgeHoliday(date){
            return UIColor.red
        }
        //土日の判定
        let weekday = self.getWeekIdx(date)
        // 日曜なら
        if weekday == 1 {
            return UIColor.red
        }
            // 土曜なら
        else if weekday == 7 {
            return UIColor.blue
        }
        return nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return practiceArray.count
        case 1:
            return gameArray.count
        default:
            return 0
        }
    }
    //セルの内容を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PracticeCell")as! PracticeTableViewCell
            cell.startTimeLabel.text = practiceArray[indexPath.row].startTime
            cell.objectiveLabel.text = practiceArray[indexPath.row].objective
            cell.placeLabel.text = practiceArray[indexPath.row].place
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell")as! GameTableViewCell
            cell.startTimeLabel.text = gameArray[indexPath.row].startTime
            cell.endTimeLabel.text = gameArray[indexPath.row].endTime
            cell.placeLabel.text = gameArray[indexPath.row].place
            cell.teamNameLabel.text = gameArray[indexPath.row].teamName
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PracticeCell")as! PracticeTableViewCell
            return cell
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // delegate スワイプのアクション
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // realmの中も削除
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: self.selectingDate)
        let month = tmpCalendar.component(.month, from: self.selectingDate)
        let day = tmpCalendar.component(.day, from: self.selectingDate)
        
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        let da = "\(year)年\(m)月\(d)日"
        
        let detailAction = UITableViewRowAction(style: .default, title: "詳細") { (detailAction, indexPath) in
            let config = Realm.Configuration(schemaVersion: 2)
            let realm = try! Realm(configuration: config)
            var result = realm.objects(Practice.self)
            result = result.filter("date == '\(da)'")
            self.selectingRowData = result[indexPath.row]
            self.performSegue(withIdentifier: "toDetail", sender: nil)
        }
        let deleteAction = UITableViewRowAction(style: .default, title: "削除") { (deleteAction, indexPath) in
            
            let alert = UIAlertController(title: "ノートを削除", message: "", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "削除", style: .destructive, handler: { (deleteAction) in
                self.practiceArray.remove(at: indexPath.row)
                self.practiceTableView.deleteRows(at: [indexPath], with: .automatic)
                alert.dismiss(animated: true, completion: nil)
                // スケジュール取得(とりあえず場所だけ取得）(マイグレーション対策）
                let config = Realm.Configuration(schemaVersion: 2)
                do {
                    let realm = try! Realm(configuration: config)
                    var result = realm.objects(Practice.self)
                    result = result.filter("date == '\(da)'")
                    self.selectingRowData = result[indexPath.row]
                    try! realm.write {
                        realm.delete(self.selectingRowData)
                    }
                }
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (cancelAction) in
    
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        detailAction.backgroundColor = UIColor.init(red: 0.00, green: 0.76, blue: 0.76, alpha: 1.00)
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction, detailAction]
    }
    
    // 選択した日にちを情報を取得し表示
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // デフォではこの表示
        //scheduleTextView.text = "ノートはありません"
        //view.addSubview(scheduleTextView)
        
        practiceArray.removeAll()
        gameArray.removeAll()
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        selectingDate = date
        
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        let da = "\(year)年\(m)月\(d)日"
        
        // クリックしたら日付が表示される
        dateLabel.text = "\(m)/\(d)"
        
        // スケジュール取得(とりあえず場所だけ取得）(マイグレーション対策）
        let config = Realm.Configuration(schemaVersion: 2)
        do {
            let realm = try! Realm(configuration: config)
            var result1 = realm.objects(Practice.self)
            result1 = result1.filter("date == '\(da)'")
            //Practiceの内容を更新
            for res in result1 {
                practiceArray.append(res)
            }
            var result2 = realm.objects(Game.self)
            result2 = result2.filter("date == '\(da)'")
            
            for res in result2 {
                gameArray.append(res)
            }
        }
        //プラクティスの内容に基づき、tableviewの内容を更新
        self.practiceTableView.reloadData()
        
         
        // tableFieldにrealmを一つずつ追加していく
       /* var number = 0
        
        for ev in result{
            let textview = UITextView(frame: CGRect(x: 16, y: 520 + 30 * number, width: Int(self.view.bounds.width), height: 30))
            textview.isEditable = false
            textview.isSelectable = false
            textview.font?.withSize(45)
            textview.textColor = UIColor.black
            textview.text = "\(ev.startTime) ー \(ev.endTime) @\(ev.place)"
            self.view.addSubview(textview)
            number = number + 1
        }*/
    }
    // 予定があるところだけドット
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        let da = "\(year)年\(m)月\(d)日"
        // スケジュール取得(とりあえず場所だけ取得）(マイグレーション対策）
        let config = Realm.Configuration(schemaVersion: 2)
        do {
            let realm = try! Realm(configuration: config)
            let results = realm.objects(Practice.self)
            for result in results {
                if da == result.date {
                    print(result.date)
                return true
                }
            }
            let results2 = realm.objects(Game.self)
            for result in results2 {
                if da == result.date {
                    print(result.date)
                return true
                }
            }
        }; return false
    }
    
    //  追加ボタンを押すとアラートを出して画面遷移()
    @IBAction func tapAddButton(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        
        alertView.addButton("練習"){
            self.performSegue(withIdentifier: "toAddPractice", sender: nil)
        }
        alertView.addButton("試合"){
            self.performSegue(withIdentifier: "toAddGame", sender: nil)
        }
        alertView.addButton("ヘルス") {
            self.performSegue(withIdentifier: "toAddHealth", sender: nil)
        }
        
        alertView.showEdit(
            "新規ノートを書く",
            subTitle: "追加する内容を選択してください",
            closeButtonTitle: "キャンセル",
            colorStyle: 0x33CCFF // 色
        )
        
    }
    //練習追加ノートに画面遷移する際にAddPracticeVが日時を受けtる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddPractice" {
            let nc = segue.destination as! UINavigationController
            let secondVC = nc.topViewController as! AddPracticeViewController
            secondVC.selectedDate = self.selectingDate
        } else if segue.identifier == "toDetail" {
            let nc = segue.destination as! UINavigationController
            let secondVC = nc.topViewController as! DetailViewController
            //secondVC.date = self.selectingRowData.date
            secondVC.selectingPractice = self.selectingRowData
        } else if segue.identifier == "toAddGame" {
            let nc = segue.destination as! UINavigationController
            let secondVC = nc.topViewController as! AddGameViewController
            secondVC.selectedDate = self.selectingDate
        }
    }
}
