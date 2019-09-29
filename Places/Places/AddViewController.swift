//
//  AddViewController.swift
//  Places
//
//  Created by Kedar Mohile on 9/28/19.
//  Copyright © 2019 Arti Karnik. All rights reserved.
//

import UIKit


class AddViewController: UIViewController , UITextFieldDelegate
{
    @IBOutlet var txtAddPlace: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    @IBAction func btnAdd(_ sender: Any)
    {
        if txtAddPlace.text != nil && txtAddPlace.text != ""
        {
            Global.sharedInstance.arrPlaces.append(txtAddPlace.text!)
            UserDefaults.standard.set(Global.sharedInstance.arrPlaces, forKey: "PlaceName")

            let alert = UIAlertController(title: "Thank you", message: "Place added", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please Enter place name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
    }
    
    
    // Touches began method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        txtAddPlace.endEditing(true)
    }

    // Text field delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtAddPlace.resignFirstResponder()
        return true
    }
}
