//
//  SatelliteViewController.swift
//  342Ass3
//
//  Created by SABai on 16/05/2016.
//  Copyright © 2016 Shaobai Li. All rights reserved.
//

import UIKit
import Foundation

class SatelliteViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var latitude: String?
    var longitude: String?
    var data: String?
    let key: String = "f0X41bJRQaBP0UYbgJ6TXNty0cOGBDBAsLqqGGO0"
    let baseURl: String = "https://api.nasa.gov/planetary/earth/imagery"
    
    
    func performNASARequest(latitude : String, longitude : String, data: String)
    {
        //https://api.nasa.gov/planetary/earth/imagery?lon=150.8931239&lat=-34.424984&date=2015-05-01&cloud_score=True&api_key=f0X41bJRQaBP0UYbgJ6TXNty0cOGBDBAsLqqGGO0
        let urlComponents = NSURLComponents(string: baseURl)!
        let lon: NSURLQueryItem = NSURLQueryItem(name:"lon", value: longitude)
        let lat: NSURLQueryItem = NSURLQueryItem(name:"lat", value: latitude)
        let date: NSURLQueryItem = NSURLQueryItem(name: "date", value: data)
        let cloud_score: NSURLQueryItem = NSURLQueryItem(name: "cloud_score", value: "True")
        let api_key:NSURLQueryItem = NSURLQueryItem(name: "api_key", value: key)
        urlComponents.queryItems = [lon, lat, date, cloud_score, api_key]
        let url = urlComponents.URL!
        print(url)
        let request = NSMutableURLRequest(URL: url)
        
        //request.HTTPMethod = "GET"
        request.timeoutInterval = 5
        request.HTTPMethod = "GET"
        
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            //Something stuffed up:
            if let e = error  {
                
                print("error")
                print(e.localizedDescription)
                
                return
                
                //Check for issues with the status code:
            } else if let d = data, let r = response as? NSHTTPURLResponse{
                
                
                //perform the cast:
                print(r.statusCode)
                
                if (r.statusCode == 200){
                    print("It worked")
                    
                    let resultString:String = NSString(data: d, encoding:NSUTF8StringEncoding)! as String
                    
                    print("RESULT IS:")
                    print(resultString)
                    print("done!!!")
                    let data: NSData = resultString.dataUsingEncoding(NSUTF8StringEncoding)!
                    var jsonObject: AnyObject?
                    //var imageURL : String?
                    do{
                        jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                        
                        
                    }
                    catch
                    {
                        print("erro when covert json string")
                    }
                    if let imageURL: String = (jsonObject as! NSDictionary)["url"] as? String
                    {
                        print(imageURL)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.timeLabel.text = (jsonObject as! NSDictionary)["date"] as? String;
                            let url = NSURL(string: imageURL)
                            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check                        self.timeLabel.text = resultString
                            self.imageView.image = UIImage(data: data!)
                            print("333");
                            
                        })                        //self.imageView.image = UIImage(data: data!)
                        //
                        //let a: UIImage = UIImage(data: data!)!
                        //return a
                    }else
                    {
                        print("not a valid location")
                        //return
                    }
                    
                    //You MUST perform UI updates on the main thread:

                    
                    
                    
                    //return
                }
                
            }
            
        }
        //This is important
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = NSCalendar.currentCalendar()
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-mm-dd"
        let a = calendar.dateByAddingUnit(.Day, value: -20, toDate: NSDate(), options: [])
        let b = format.stringFromDate(a!)
        print(b)
        
        latitude = "-34.424984"
        longitude = "150.8931239"
        data = "2016-01-01"
        performNASARequest(latitude!, longitude: longitude! , data: data!)
        performNASARequest(latitude!, longitude: longitude! , data: "2016-5-1")
        print("xixix")
        self.reloadInputViews()
        //timeLabel.text = "test-test-test-test"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
