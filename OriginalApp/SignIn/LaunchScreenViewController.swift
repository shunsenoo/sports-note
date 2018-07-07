
import UIKit
import LTMorphingLabel

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet var titleLabel: LTMorphingLabel!
    var timer :Timer = Timer()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timer = Timer.scheduledTimer(timeInterval: 3.0,
                                                       target: self,
                                                       selector: #selector(changeView),
                                                       userInfo: nil,
                                                       repeats: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //titleLabel.morphingEffect = .evaporate
        //titleLabel.text = "Sporte"
    }

    @objc func changeView() {
        self.performSegue(withIdentifier: "toFirst", sender: nil)
    }

}
