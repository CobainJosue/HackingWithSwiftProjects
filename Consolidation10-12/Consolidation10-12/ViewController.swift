//
//  ViewController.swift
//  Consolidation10-12
//
//  Created by Josue Emanuel Quinones Rivera on 3/29/19.
//  Copyright © 2019 Josue Emanuel Quinones Rivera. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takePhoto))
        
        read()
        
    }
    
    @objc func takePhoto() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.delegate = self
        present(picker, animated: true)
    }

    func read() {
        let defaults = UserDefaults.standard
        
        if let savedArray = defaults.object(forKey: "items") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                items = try jsonDecoder.decode([Item].self, from: savedArray)
            } catch {
                print("Failed to load people.")
            }
        }
    }
    
    func save(){
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(items) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "items")
        } else {
            print("Failed to save data.")
        }
    }

}

// MARK: Image Picker
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true) {
            let ac = UIAlertController(title: "Captions", message: "Tell me about it", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [unowned self] _ in
                let captions = ac.textFields?[0].text ?? "nothing to say"
                let item = Item(photo: imageName, captions: captions)
                self.items.append(item)
                self.save()
                self.tableView.reloadData()
            }))
            self.present(ac, animated: true)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


//MARK: TableView
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].captions
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let path = getDocumentsDirectory().appendingPathComponent(items[indexPath.row].photo)
            vc.image = path
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
