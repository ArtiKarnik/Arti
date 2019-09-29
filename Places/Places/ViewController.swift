//
//  ViewController.swift
//  Places
//
//  Created by Kedar Mohile on 9/28/19.
//  Copyright © 2019 Arti Karnik. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController , MKMapViewDelegate
{
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        setLocationInMap()
    }
    
    // Get latitude and longitude from Place name
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void )
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0]
                {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    // set location in map
    func setLocationInMap()
    {
        var placeName : String = (Global.sharedInstance.arrPlaces[Global.sharedInstance.intSelectedRow])
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(placeName, completionHandler: {(placemark , error) -> Void in
            
            if error != nil
            {
                let alert = UIAlertController(title: "Place not found", message: "Please delete place name and add new one!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                print("\(error.debugDescription)")
            }
            else
            {
                let pc: CLPlacemark! = placemark?[0]
                if let location =  pc.location
                {
                    print(location.coordinate.latitude, location.coordinate.longitude)
                    let lat = location.coordinate.latitude
                    let lon  = location.coordinate.longitude
                    let latDelta = 0.01
                    let lonDelta = 0.01
                    
                    let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01 ,longitudeDelta: 0.01)
                    let loc : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                    let region : MKCoordinateRegion = MKCoordinateRegion(center: loc, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = loc
                    annotation.title = "I want to go there! "
                    self.mapView.addAnnotation(annotation)
                }
            }
            
        })
    }
}
