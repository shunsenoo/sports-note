
import UIKit


class ObjectiveViewController: UIViewController {
    

    @IBOutlet var segmentButton: UISegmentedControl!
    
    var pageViewController: PageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = self.childViewControllers.first as? PageViewController
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func segmentButton(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
             pageViewController.selectFirstView()
        case 1:
            pageViewController.selectSecondView()
        case 2:
            pageViewController.selectThirdView()
        default:
            pageViewController.selectFirstView()
        }
    }
    
}
