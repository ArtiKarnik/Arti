//
//  TableViewController.swift
//  Places
//
//  Created by Kedar Mohile on 9/28/19.
//  Copyright © 2019 Arti Karnik. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController
{
    @IBOutlet var tblView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        getSavedPlaces()
        tblView.reloadData()
        
    }
    // Table view delegate methods
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Global.sharedInstance.arrPlaces.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Global.sharedInstance.arrPlaces[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        Global.sharedInstance.intSelectedRow = indexPath.row
        return indexPath
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            Global.sharedInstance.arrPlaces.remove(at: indexPath.row)
            UserDefaults.standard.set(Global.sharedInstance.arrPlaces, forKey: "PlaceName")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Retrieve saved palces
    func getSavedPlaces()
    {
        if let arr = UserDefaults.standard.array(forKey: "PlaceName")
        {
            Global.sharedInstance.arrPlaces = UserDefaults.standard.array(forKey: "PlaceName") as! [String]
            
        }
        print(Global.sharedInstance.arrPlaces)
    }
}
