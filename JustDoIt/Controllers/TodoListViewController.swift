//
//  ViewController.swift
//  JustDoIt
//
//  Created by Rick D on 2018/03/28.
//  Copyright © 2018 Firefly. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.uiColorHex)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count))  {
                cell.backgroundColor = color
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added."
        }

        return cell
    }

    //MARK - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
 
    }
    
    //MARK Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
        }
        
        let confirm = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if  textField.text != "" {
                if let currentCategory = self.selectedCategory{
                    
                    do {
                        try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
      
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    } catch {
                        print("Error saving new items. \(error)")
                    }
                    
                }
            }
    
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item."
            textField = alertTextField
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            
            
            do {
                try realm.write() {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item! \(error)")
            }
            
            
        }
        
    }
    
    
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}
 

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



















