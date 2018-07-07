//
//  SlideMenuViewController.swift
//  OriginalApp
//
//  Created by 妹尾駿 on H30/06/18.
//  Copyright © 平成30年 porme.inc. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideMenuViewController: SlideMenuController {
    
    override func awakeFromNib() {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "Home")
        let leftVC = storyboard?.instantiateViewController(withIdentifier: "Left")
        //UIViewControllerにはNavigationBarは無いためUINavigationControllerを生成しています。
        let navigationController = UINavigationController(rootViewController: mainVC!)
        //ライブラリ特有のプロパティにセット
        mainViewController = navigationController
        leftViewController = leftVC
        super.awakeFromNib()
        
        SlideMenuOptions.leftViewWidth = 270.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
