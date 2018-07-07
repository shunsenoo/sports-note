

import Foundation
import RealmSwift

class Objective: Object {
    @objc dynamic var duration:Int!
    @objc dynamic var title:String!
    @objc dynamic var detail: String!
    @objc dynamic var deadlineDate:date!

}
