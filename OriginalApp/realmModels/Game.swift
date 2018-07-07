

import Foundation
import RealmSwift

class Game: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var date = ""
    @objc dynamic var place = ""
    @objc dynamic var startTime = ""
    @objc dynamic var endTime = ""
    @objc dynamic var groundCondition = ""
    @objc dynamic var weather = ""
    @objc dynamic var objective = ""
    @objc dynamic var teamScore1: Int = 0
    @objc dynamic var teamScore2: Int = 0
    @objc dynamic var teamName = ""
    
    // プライマリーキーを設定
    override static func primaryKey() -> String?{
        return "id"
    }
}
