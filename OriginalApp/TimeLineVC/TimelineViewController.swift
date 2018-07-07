
import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var timeLineTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        
        let nib = UINib(nibName: "TimeLineTableViewCell", bundle: Bundle.main)
        timeLineTableView.register(nib, forCellReuseIdentifier: "TimelineCell")
        timeLineTableView.tableFooterView = UIView()
        timeLineTableView.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell") as! TimeLineTableViewCell
        cell.userNameLabel.text = "サンプル"
        return cell
    }
    @IBAction func tapMenuButton(){
        self.slideMenuController()?.openLeft()
        
    }

}
