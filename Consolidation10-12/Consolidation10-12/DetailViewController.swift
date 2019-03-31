//
//  DetailViewController.swift
//  Consolidation10-12
//
//  Created by Josue Emanuel Quinones Rivera on 3/29/19.
//  Copyright © 2019 Josue Emanuel Quinones Rivera. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var image: URL?
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let selectedImage = image {
            print("image: \(selectedImage)")
            imageView.image = UIImage(contentsOfFile: selectedImage.path)
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
