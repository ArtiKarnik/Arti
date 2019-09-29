//
//  ViewController.swift
//  Where I am
//
//  Created by Kedar Mohile on 9/27/19.
//  Copyright © 2019 Arti Karnik. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate
{
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    
    @IBOutlet var lblLatitude: UILabel!
    @IBOutlet var lblLongitude: UILabel!
    @IBOutlet var lblAltitude: UILabel!
    @IBOutlet var lblSpeed: UILabel!
    @IBOutlet var lblCourse: UILabel!
    @IBOutlet var lblAddress: UILabel!
    
    override func viewDidLoad()
    {
        getLocation()
        
        super.viewDidLoad()
   }

    func getLocation()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
        }
    }
    // set labels from location
    func updateCurrentLocation (location : CLLocation)
    {
        lblLatitude.text = "\(location.coordinate.latitude)"
        lblLongitude.text = "\(location.coordinate.longitude)"
        lblAltitude.text = "\(location.altitude)"
        lblSpeed.text = "\(location.speed)"
        lblCourse.text = "\(location.course)"
    }

    // fetch address from location
    func fetchAddressFromLocation (location : CLLocation)
    {
        var address : String = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemark , error) -> Void in
           
        if (error != nil)
        {
            self.lblAddress.text = "\(error.debugDescription)"
        }
        else
        {
            var pc: CLPlacemark! = placemark?[0]
           
            // Location name
            if (pc != nil)
            {
                if let name = pc.name // name
                {
                    address.append("\(name)")
                }
                if let aptNo = pc.subThoroughfare
                {
                    address.append("\n\(aptNo)")
                }
                if let thorough = pc.thoroughfare
                {
                    address.append("  \(thorough)")
                }
                if let sublocality = pc.subLocality
                {
                    address.append("\n\(sublocality)")
                }
                if let locality = pc.locality
                {
                    address.append("\n\(locality)")
                }
                if let postal = pc.postalCode
                {
                    address.append("\n\(postal)")
                }
                if let country = pc.country
                {
                   address.append("\n\(country)")
                }
            }
            self.lblAddress.text = address
        }
        })
       
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
      
        let lc = locations.last! as CLLocation
        updateCurrentLocation(location: lc)
        fetchAddressFromLocation(location: lc)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
}

