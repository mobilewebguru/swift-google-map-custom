

import Foundation
import UIKit


public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}
public extension CGFloat {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: CGFloat {
        return CGFloat(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}

public extension UIView {
    
    
    func zoomInUser(with delay:Double) {
        
        
        UIView.animate(withDuration: kAnimationDurationTimeConstant,delay:delay, animations: {
            
            self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            
        }){ (_) in
            
        }
        
    }
    func zoomOutUser(with delay:Double)  {
        
        
        
        
        UIView.animate(withDuration: kAnimationDurationTimeConstant,delay:kAnimationZoomOutDelay  + delay, animations: {
            
            self.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
        }) { (_) in
            self.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
            
        }
        
    }
    
}
