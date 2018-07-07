

import UIKit
import RealmSwift
import NCMB
import SVProgressHUD

class CreateGroupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var groupNameTextField: UITextField!
    @IBOutlet var groupIDTextField: UITextField!
    @IBOutlet var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameTextField.delegate = self
        groupIDTextField.delegate = self
        // Do any additional setup after loading the view.
        createButton.layer.cornerRadius = createButton.layer.fs_height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func createGroup(){
        SVProgressHUD.show()
        let newRole = NCMBRole(name: groupNameTextField.text)
        newRole?.objectId = groupIDTextField.text
        newRole?.saveInBackground({ (error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            } else {
                SVProgressHUD.dismiss()
                self.tabBarController?.selectedIndex = 0
            }
        })
    }
}
