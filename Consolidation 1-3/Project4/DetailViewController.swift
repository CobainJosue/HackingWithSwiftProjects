//
//  DetailViewController.swift
//  Project4
//
//  Created by Josue Quiñones on 2/25/19.
//  Copyright © 2019 Josue Quiñones. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var flagSelected: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let flag = flagSelected {
            imageView.image = UIImage(named: flag)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
    }
    
    @objc func shareTapped() {
        
        if let image = imageView.image?.jpegData(compressionQuality: 0.8) {
            
            
            
            let avc = UIActivityViewController(activityItems: [image, flagSelected ?? "Unknown image name"], applicationActivities: [])
            avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            
            present(avc, animated:  true)
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
