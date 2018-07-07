
import UIKit
import NCMB
import SlideMenuControllerSwift



class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPwTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let border1 = CALayer()
        let width = CGFloat(2.0)
        
        border1.borderColor = UIColor.white.cgColor
        border1.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width: nameTextField.frame.size.width , height: 1)
        border1.borderWidth = width
        
        let border2 = CALayer()
        border2.borderColor = UIColor.white.cgColor
        border2.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width: emailTextField.frame.size.width , height: 1)
        border2.borderWidth = width
        
        let border3 = CALayer()
        border3.borderColor = UIColor.white.cgColor
        border3.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width, width: emailTextField.frame.size.width , height: 1)
        border3.borderWidth = width
        
        let border4 = CALayer()
        border4.borderColor = UIColor.white.cgColor
        border4.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width, width: emailTextField.frame.size.width , height: 1)
        border4.borderWidth = width
        
        nameTextField.layer.addSublayer(border1)
        emailTextField.layer.addSublayer(border2)
        passwordTextField.layer.addSublayer(border3)
        confirmPwTextField.layer.addSublayer(border4)
        
        self.signUpButton.layer.cornerRadius = 25
        
        confirmPwTextField.isSecureTextEntry = true
        passwordTextField.isSecureTextEntry = true
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPwTextField.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func checkView(_ sender: CheckBox) {
        
        print(sender.isChecked)
        
    }
   
    @IBAction func signUp(){
        if nameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" && confirmPwTextField.text != "" {
            if confirmPwTextField.text == passwordTextField.text {
                //NCMBUserのインスタンスを作成
                let user = NCMBUser()
                //ユーザー名を設定
                user.userName = nameTextField.text
                user.mailAddress = emailTextField.text
                //パスワードを設定
                user.password = passwordTextField.text
                //会員の登録を行う
                user.signUpInBackground { (error) in
                    if error != nil {
                        print("error")
                    }else{
                        // 新規登録成功時の処理
                        let storyboard = UIStoryboard(name:  "Main", bundle: Bundle.main)
                        let tabbarController = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! TabbarViewController
                        let menuController = storyboard.instantiateViewController(withIdentifier: "Left") as! LeftMenuViewController
                        let slideMenuController = SlideMenuController(mainViewController: tabbarController, leftMenuViewController: menuController)
                        UIApplication.shared.keyWindow?.rootViewController = slideMenuController
                        
                        // ログイン状態の保持
                        let ud = UserDefaults.standard
                        ud.set(true, forKey: "islogin")
                        ud.synchronize()
                    }
                }
            } else {
                let alert = UIAlertController(title: "パスワードが一致しません", message: nil, preferredStyle: .alert)
                let okaction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okaction)
                self.present(alert, animated: true, completion: nil)
        }
        } else {
            let alert = UIAlertController(title: "注意", message: "項目を全て埋めてください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPwTextField.resignFirstResponder()
        return true
    }
}
