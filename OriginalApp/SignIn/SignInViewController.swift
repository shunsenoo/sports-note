//
//  SignInViewController.swift
//  OriginalApp
//
//  Created by 妹尾駿 on H30/06/18.
//  Copyright © 平成30年 porme.inc. All rights reserved.
//

import UIKit
import NCMB
import SlideMenuControllerSwift

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view.
        let border1 = CALayer()
        let width = CGFloat(2.0)
        
        border1.borderColor = UIColor.white.cgColor
        border1.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width: emailTextField.frame.size.width - 25, height: 1)
        border1.borderWidth = width
        
        let border2 = CALayer()
        border2.borderColor = UIColor.white.cgColor
        border2.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width, width: passwordTextField.frame.size.width - 25, height: 1)
        border2.borderWidth = width
        
        emailTextField.placeholder = "メールアドレス"
        passwordTextField.placeholder = "パスワード"
        emailTextField.layer.addSublayer(border1)
        passwordTextField.layer.addSublayer(border2)
        
        self.signInButton.layer.cornerRadius = 25
        self.signUpButton.layer.cornerRadius = 25
        
        self.passwordTextField.isSecureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(){
        
        if (emailTextField.text?.count)! > 0 && (passwordTextField.text?.count)! > 0 {
            NCMBUser.logInWithMailAddress(inBackground: emailTextField.text, password: passwordTextField.text) { (user, error) in
                if error != nil {
                    let alertController = UIAlertController(title: "ログインエラー", message: "メールアドレスまたはパスワードが正しくありません。", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (acttion) in
                        alertController.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(alertAction)
                }else{
                    // ログイン成功
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

                    /*let mainViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                    let leftViewController = storyboard.instantiateViewController(withIdentifier: "Left") as! LeftMenuViewController
                    
                    let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                    
                    let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)*/
                    
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
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
