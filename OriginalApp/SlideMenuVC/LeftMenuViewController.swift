//
//  LeftMenuViewController.swift
//  OriginalApp
//
//  Created by 妹尾駿 on H30/06/18.
//  Copyright © 平成30年 porme.inc. All rights reserved.
//

import UIKit
import NCMB


class LeftMenuViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
    

    // 要素
    var posts:[String] = ["設定","お問い合わせ","アプリの使い方"]
    var EngPosts: [String] = ["Setting","Inquiry","How to use"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        self.logOutButton.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int { // sectionの数を決める
        return 1
    }
    
    
    //MARK: cellSetting
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = posts[indexPath.row]
        cell.detailTextLabel?.text = EngPosts[indexPath.row]
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toSetting", sender: nil)
        }
    }
    
    @IBAction func logout(){
        NCMBUser.logOutInBackground { (error) in
            if error != nil {
                print("error")
            } else {
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
                UIApplication.shared.keyWindow?.rootViewController = viewController
                
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
            }
        }
    }
    
}
