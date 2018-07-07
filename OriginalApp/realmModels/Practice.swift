
import Foundation
import RealmSwift

class Practice: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var date = ""
    @objc dynamic var place = ""
    @objc dynamic var startTime = ""
    @objc dynamic var endTime = ""
    @objc dynamic var condition = ""
    @objc dynamic var weather = ""
    @objc dynamic var objective = ""
    @objc dynamic var achievement = ""
    @objc dynamic var category = ""
    @objc dynamic var content = ""
    @objc dynamic var goods = ""
    @objc dynamic var bads = ""
    @objc dynamic var tips = ""
    
    // プライマリーキーを設定
    override static func primaryKey() -> String?{
        return "id"
    }
    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
