
import Foundation
import CoreLocation
import UIKit

struct User {
    
    var id = ""
    var name = ""
    var location = CLLocationCoordinate2D.init()
    var movementRadius:CLLocationDegrees = 0.004
    var image:UIImage = #imageLiteral(resourceName: "user")

    static func dummyUsers() -> [User]{
        
        // (52.5217441300032 13.4027397190117)
        let u1 = User.init(id: "1", name: "Test", location: CLLocationCoordinate2D.init(latitude: 52.5217441300032, longitude: 13.4027397190117), movementRadius: 0.00005,image:#imageLiteral(resourceName: "user"))
        // 52.5201350345044 13.4009176753785
        let u2 = User.init(id: "2", name: "Test2", location: CLLocationCoordinate2D.init(latitude: 52.5201350345044, longitude: 13.4009176753785), movementRadius: 0.00005,image:#imageLiteral(resourceName: "user"))
        // 52.5202885700027 13.4061499995981
//        let u3 = User.init(id: "3", name: "Test3", location: CLLocationCoordinate2D.init(latitude: 52.5202885700027, longitude: 13.4061499995981), movementRadius: 0.00005,image:#imageLiteral(resourceName: "user"))
        // 52.5218461806564 13.4061002507844
        let u4 = User.init(id: "4", name: "Test4", location: CLLocationCoordinate2D.init(latitude: 52.5210461806564, longitude: 13.4061002507844), movementRadius: 0.00005,image:#imageLiteral(resourceName: "user"))
        // 52.5218461806564 13.4061002507844
        let u5 = User.init(id: "5", name: "Test5", location: CLLocationCoordinate2D.init(latitude: 52.520189390232, longitude: 13.4061337507844), movementRadius: 0.00005,image:#imageLiteral(resourceName: "user"))
        return [u1,u2,u4,u5]
        
    }

}


