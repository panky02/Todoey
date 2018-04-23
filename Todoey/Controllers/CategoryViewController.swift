//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pankaj Kumar on 19/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import UIKit
import RealmSwift



class CategoryViewController: SwipeTableViewController {

    var categories :Results<Category>?
    
    let realm = try! Realm()
    
    //let categoryContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    //MARK:- TableView Datsource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        
        //nil COALESCING operator ?? which is used when we have to pass a default value to protect our code from breaking if categories is nil
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //what to show in Table view reuable Cell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"

        return cell
    }
    
    //MARK:- Data Manipulation Methods
    func saveCategory(category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error while saving new category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        
   }
    //MARK: - Delete Category
    override func updateModel(indexPath: IndexPath) {
      
        if let selCategory = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(selCategory)
                }
            } catch {
                print("error while deleting \(error)")
            }
            //tableView.reloadData() // now with "editActionsOptionsForRowAt" swipeCellKit method, there is no need to reloadData of tableview
        }
    }
    
    
    //MARK:- Add new Categories
    
    @IBAction func addCategroryBtnPressed(_ sender: UIBarButtonItem) {
        
        let categoryAlert = UIAlertController(title: "To Add New Category", message: "", preferredStyle: .alert)
        
        var categoryText = UITextField()
        
        let alertBtn = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //this Closure will be triggered when the Add Category btn is pressed
            
            let categoryItem = Category()
            categoryItem.name = categoryText.text!
           
            self.saveCategory(category: categoryItem)
            
        }
        categoryAlert.addTextField { (textField) in
            textField.placeholder = "Type a new Category Name"
            categoryText = textField
        }
        categoryAlert.addAction(alertBtn)
        
        present(categoryAlert, animated: true)
    
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}

