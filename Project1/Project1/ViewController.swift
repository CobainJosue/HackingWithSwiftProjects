//
//  ViewController.swift
//  Project1
//
//  Created by Josue Quiñones on 2/24/19.
//  Copyright © 2019 Josue Quiñones. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var showCounters = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Storm Viewer"
        
        performSelector(inBackground: #selector(getImages), with: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendTapped))
        
    }
    
    @objc func getImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        if let items = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(item)
                    showCounters.append(0)
                }
            }
            
            pictures.sort()
            print(pictures)
            
            let defaults = UserDefaults.standard
            if let countersSaved = defaults.value(forKey: "counters") as? [Int] {
                showCounters = countersSaved
            }
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(showCounters, forKey: "counters")
    }
    
    @objc func recommendTapped() {
        let vc = UIActivityViewController(activityItems: ["http://itunes.apple.com/MyApp"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Times shown: \(showCounters[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showCounters[indexPath.row] += 1
        
        save()
        tableView.reloadData()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.currentPicture = indexPath.row + 1
            vc.numberOfPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

