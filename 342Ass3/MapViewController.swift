//
//  MapViewController.swift
//  342Ass3
//
//  Created by SABai on 18/05/2016.
//  Copyright © 2016 Shaobai Li. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController
{

    
    @IBOutlet weak var next: UIButton!
    @IBOutlet weak var map: MKMapView!
    var annotation: MKPointAnnotation? = nil
    var latitude: String? = nil
    var longitude: String? = nil
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let target = segue.destinationViewController as! UINavigationController
        let destination = target.topViewController as! SatelliteViewController
        destination.longitude = longitude
        destination.latitude = latitude
        print(latitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        next.hidden = true
        let longpress = UILongPressGestureRecognizer(target: self, action: "addAnnotation:")
        longpress.minimumPressDuration = 1.5
        map.addGestureRecognizer(longpress)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began{
            if annotation != nil{
                self.map.removeAnnotation(annotation!)
            }
            next.hidden = false
            let touchPoint = gestureRecognizer.locationInView(map)
            let newCoordinates = map.convertPoint(touchPoint, toCoordinateFromView: map)
            annotation = MKPointAnnotation()
            annotation!.coordinate = newCoordinates
            map.addAnnotation(annotation!)
            latitude = String(newCoordinates.latitude)
            longitude = String(newCoordinates.longitude)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
