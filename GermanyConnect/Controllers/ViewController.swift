

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    
    // MARK: - IBOutlets
    @IBOutlet weak var changeAnimationBaseSegmentControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var animatedUser: UIImageView!
    
    private let user:[User] = User.dummyUsers()
    private var annotations:[DummyAnnotationView] = []
    
    // Repeat timer
    private var repeatUserShowTimer = Timer.init()
    
    var isNeedToShowAnimation = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set Map's Region
        setupAnnotationViews()
        setupMapToCenter()
        // setup animated for First Time
        self.animatedUser.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        
        // Set Timer to handle Animation and user's
        repeatUserShowTimer = Timer.scheduledTimer(timeInterval: kAnimationWholeDuration, target: self, selector: #selector(setupTimerAnimation), userInfo: nil, repeats: true)
        
    }
    // Setup Annotation Views()
    private func setupAnnotationViews() {
        
        for usr in self.user {
            
            let vw = Bundle.main.loadNibNamed("DummyAnnotationView", owner: nil, options: nil)![0] as! DummyAnnotationView
            vw.center = self.getRandomScreenPointBased(on: usr.location, withRegion: usr.movementRadius)
            vw.frame = CGRect.init(x: vw.center.x - 10.0, y: vw.center.y - 10.0, width: 20.0, height: 20.0)
            vw.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
            vw.userInfo = usr
            self.view.addSubview(vw)
            
            self.annotations.append(vw)
            
        }
        
        
        
    }
    
    
    // MARK:- Class functions
    private func setupMapToCenter() {
        
        self.mapView.setCenter(kDemoCurrentLocation, animated: true)
        let latDelta: CLLocationDegrees = 0.009
        let lonDelta: CLLocationDegrees = 0.009
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let region = MKCoordinateRegionMake(kDemoCurrentLocation, span)
        self.mapView.delegate = self
        self.mapView.setRegion(region, animated: false)
        
        
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let zoomWidth = mapView.visibleMapRect.size.width
        let zoomFactor = Int(log2(zoomWidth)) - 9
      
        
        self.isNeedToShowAnimation = zoomFactor <= 2
        self.updateAnnotationsPosition()
        
    }
    // Repeat Timer functions
    @objc private func setupTimerAnimation() {
        
        // Check
        assert(kAnimationWholeDuration > (kAnimationZoomOutDelay + kAnimationDurationTimeConstant)  , "Whole Animation duration must be greater than sum of zoom out delay and animtion time.")
        
        
        
        // When location is based on the screen
        // It picks any random point in the screen and display's the animation on the screen
        if self.changeAnimationBaseSegmentControl.selectedSegmentIndex == 1 {
            
            
            let randomPoint = self.getRandomScreenPoint()
            print(randomPoint)
            self.animatedUser.center = randomPoint
            
            self.animatedUser.zoomInUser(with: 0.0)
            self.animatedUser.zoomOutUser(with: 0.0)
            
            
        } else {
            // Check the centre location and provde you the point to show
            if self.isNeedToShowAnimation {
            
            
            for i in 0..<self.annotations.count {
                
                let vw = self.annotations[i]
                let randomPoint = self.getRandomScreenPointBased(on: vw.userInfo.location, withRegion: vw.userInfo.movementRadius)
                
                if self.checkPointLiesInCurrentScreenView(with: randomPoint) {
                vw.center = randomPoint
                    
                vw.zoomInUser(with: Double( i) / 10.0 )
                vw.zoomOutUser(with: Double(i) / 10 )
                
                } else {
                    
                    vw.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)

                }
                
            }
        
            
            } else {
                
                
                self.updateAnnotationsPosition()
                
            }
        }
        
        
    }
    

    func updateAnnotationsPosition() {
        
        if self.changeAnimationBaseSegmentControl.selectedSegmentIndex == 1 {return}
        if self.isNeedToShowAnimation { return }
        for vw in self.annotations {
            
            let vwLocation = vw.userInfo.location
            print(vw.center)
            
              vw.center = self.mapView.convert(CLLocationCoordinate2D.init(latitude: vwLocation.latitude, longitude: vwLocation.longitude), toPointTo: self.mapView)
            
            
            vw.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        
        }

        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func animationBasedControlChanged(_ sender: UISegmentedControl) {
        
    
        
        
    }
    
    
    // Generate Random Screen Point
    func getRandomScreenPoint() -> CGPoint {
        
        
        
        // Create minimum area to start for the point to find
        let minimumLeadingPadding = self.animatedUser.frame.size.width > kScreenLeadingPadding ? self.animatedUser.frame.size.width : kScreenLeadingPadding
    
        let minimumTopPadding = self.animatedUser.frame.size.height > kScreenTopPadding ? self.animatedUser.frame.size.height : kScreenTopPadding
        
        
        let minimumTrailingPadding = self.animatedUser.frame.size.width > kScreenTrailingPadding ? self.animatedUser.frame.size.width : kScreenTrailingPadding
        
        let minimumBottomPadding = self.animatedUser.frame.size.height > kScreenBottomPadding ? self.animatedUser.frame.size.height : kScreenBottomPadding
        
        
        
        // Available
        let screenHeight = self.view.frame.size.height - minimumBottomPadding
        let screenWidth = self.view.frame.size.width - minimumTrailingPadding
        
        
        //Finds random CGFloat within the start and end available area
        let yPos = CGFloat.random(min: minimumTopPadding, max: screenHeight)
        let xPos = CGFloat.random(min: minimumLeadingPadding, max: screenWidth)
        
        return CGPoint.init(x: xPos, y: yPos)
        
    }
    func getRandomScreenPointBased(on centreCoordinate:CLLocationCoordinate2D, withRegion delta:CLLocationDegrees) -> CGPoint {
    
        
        let minLat = Double(centreCoordinate.latitude - delta)
        let maxLat = Double(centreCoordinate.latitude + delta)
        let minLong = Double(centreCoordinate.longitude - delta)
        let maxLong = Double(centreCoordinate.longitude + delta)

        
        let randomLat = Double.random(min: minLat, max: maxLat)
        let randomLong = Double.random(min: minLong, max: maxLong)
        
        
        return self.mapView.convert(CLLocationCoordinate2D.init(latitude: randomLat, longitude: randomLong), toPointTo: self.mapView)
        
        
    }
    
    func checkPointLiesInCurrentScreenView(with point:CGPoint) -> Bool {
        
        
        
        // Create minimum area to start for the point to find
        let minimumLeadingPadding = self.animatedUser.frame.size.width > kScreenLeadingPadding ? self.animatedUser.frame.size.width : kScreenLeadingPadding
        
        let minimumTopPadding = self.animatedUser.frame.size.height > kScreenTopPadding ? self.animatedUser.frame.size.height : kScreenTopPadding
        
        
        let minimumTrailingPadding = self.animatedUser.frame.size.width > kScreenTrailingPadding ? self.animatedUser.frame.size.width : kScreenTrailingPadding
        
        let minimumBottomPadding = self.animatedUser.frame.size.height > kScreenBottomPadding ? self.animatedUser.frame.size.height : kScreenBottomPadding
        
        
        
        // Available
        let screenHeight = self.view.frame.size.height - minimumBottomPadding
        let screenWidth = self.view.frame.size.width - minimumTrailingPadding
        
        return minimumLeadingPadding <= point.x && point.x <= screenHeight && minimumTopPadding <= point.y && point.y <= screenWidth
        

        
        
    }
    
    
    
//    func zoomInUser(for vw:UIView) {
//
//
//        UIView.animate(withDuration: kAnimationDurationTimeConstant, animations: {
//
//            vw.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
//
//        }){ (_) in
//
//        }
//
//    }
//    func zoomOutUser(for vw:UIView) {
//
//
//
//
//        UIView.animate(withDuration: kAnimationDurationTimeConstant,delay:kAnimationZoomOutDelay, animations: {
//
//            vw.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
//
//        }) { (_) in
//            vw.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
//
//        }
//
//    }
    
}

