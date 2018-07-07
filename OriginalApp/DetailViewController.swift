//
//  DetailViewController.swift
//  OriginalApp
//
//  Created by 妹尾駿 on H30/05/26.
//  Copyright © 平成30年 porme.inc. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var endTimeTextField: UITextField!
    @IBOutlet var objectiveTextField: UITextField!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var achievementLabel: UILabel!
    @IBOutlet weak var goodsTextView: UITextView!
    @IBOutlet weak var badsTextView: UITextView!
    @IBOutlet weak var tipsTextView: UITextView!
   
    var id : Int!
    var selectingPractice: Practice!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        id = selectingPractice.id
        nameLabel.text = selectingPractice.date
        startTimeTextField.text = selectingPractice.startTime
        endTimeTextField.text = selectingPractice.endTime
        objectiveTextField.text = selectingPractice.objective
        conditionLabel.text = selectingPractice.condition
        weatherLabel.text = selectingPractice.weather
        achievementLabel.text = selectingPractice.achievement
        goodsTextView.text = selectingPractice.goods
        badsTextView.text = selectingPractice.bads
        tipsTextView.text = selectingPractice.tips
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(){
        print("save")
    }
    @IBAction func delete(){
        let config = Realm.Configuration(schemaVersion: 2)
        do {
            let realm = try! Realm(configuration: config)
            var result = realm.objects(Practice.self)
            result = result.filter("id == \(id)")
            try! realm.write {
                realm.delete(result)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}
