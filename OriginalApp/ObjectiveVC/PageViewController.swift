

import UIKit

class PageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectFirstView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func selectFirstView() {
        if let firstVC = storyboard?.instantiateViewController(withIdentifier: "FirstVC") as? ShortObjectiveVC {
            self.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }
    func selectSecondView() {
        if let firstVC = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as? ShortObjectiveVC {
            self.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }
    func selectThirdView() {
        if let firstVC = storyboard?.instantiateViewController(withIdentifier: "ThirdVC") as? ShortObjectiveVC {
            self.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }
        
    
}
