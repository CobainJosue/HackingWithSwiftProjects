//
//  ViewController.swift
//  Project4
//
//  Created by Josue Quiñones on 2/25/19.
//  Copyright © 2019 Josue Quiñones. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var flags = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.bundleURL.appendingPathComponent("flags").appendingPathExtension("json")
        
        let flagsFile = try! String(contentsOf: path)
        
        flags = flagsFile.components(separatedBy: ",")
        
        print(flags)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        cell.textLabel?.text = flags[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.flagSelected = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

