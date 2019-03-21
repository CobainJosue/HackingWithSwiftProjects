//
//  ViewController.swift
//  Project1
//
//  Created by Josue Quiñones on 2/24/19.
//  Copyright © 2019 Josue Quiñones. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()

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
                }
            }
            
            pictures.sort()
            print(pictures)
            
            collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
            
        }
    }
    
    @objc func recommendTapped() {
        let vc = UIActivityViewController(activityItems: ["http://itunes.apple.com/MyApp"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! Item
        cell.name.text = pictures[indexPath.item]
        cell.image.image = UIImage(named: pictures[indexPath.item])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.currentPicture = indexPath.item
            vc.numberOfPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

