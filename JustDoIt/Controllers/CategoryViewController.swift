//
//  CategoryViewController.swift
//  JustDoIt
//
//  Created by Rick D on 2018/03/29.
//  Copyright © 2018 Firefly. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()

        tableView.separatorStyle = .none
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."
  
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].uiColorHex ?? "1D9BF6")


        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    //MARK:  - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                
                newCategory.uiColorHex = UIColor.randomFlat.hexValue()
                
                self.save(category: newCategory)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add a new category."
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Couldn't delete category")
            }
        }
        
    }
    
    
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Swipe Cell Delegate Methods



