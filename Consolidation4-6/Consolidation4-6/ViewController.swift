//
//  ViewController.swift
//  Consolidation4-6
//
//  Created by Josue Quiñones on 3/5/19.
//  Copyright © 2019 Josue Quiñones. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(cleanTable))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newItem))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        toolbarItems = [spacer, share]
        navigationController?.isToolbarHidden = false
        
    }
    
    @objc func shareTapped() {
        let list = shoppingList.joined(separator: "\n")
        let activity = UIActivityViewController(activityItems: [list], applicationActivities: [])
        activity.popoverPresentationController?.barButtonItem = toolbarItems?[1]
        present(activity, animated: true)
    }

    
    @objc func cleanTable() {
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Clear list", style: .destructive, handler: { [unowned self] _ in
            self.shoppingList.removeAll()
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func newItem() {
        let ac = UIAlertController(title: "New item", message: "Write the new item to buy", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [unowned self, unowned ac] action in
            
            guard let item = ac.textFields?[0].text else { return }
            
            self.shoppingList.insert(item, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    

}





extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

