//
//  ViewController.swift
//  Todoey
//
//  Created by Pankaj Kumar on 16/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var todoItems :Results<Item>?
    var selectedCategory :Category? {
        didSet{
            loadItems()
        }
    }
    
    //for using CORE DATA-- let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //as we are using the entire UITableViewController so we donot see any delegate or datasource initialisation
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }
    
    //MARK - Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added yet"
        }
        
        return cell
    }
    
    //MARK - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(todoItems[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("error while updating done value \(error)")
            }
        }
            tableView.reloadData()
        
      
    }
    
    //MARK - add new item button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newTodoName = UITextField()
        let itemAddAlert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this part handles what should happen after clicking on add item button in Alert
            
            if let currentCategory = self.selectedCategory {
                
                do{
                    try self.realm.write {
                        let addTodoItem = Item()
                        addTodoItem.title = newTodoName.text!
                        addTodoItem.dateCreated = Date()
                        currentCategory.items.append(addTodoItem)
                    }
                } catch {
                    print("some error occured in context \(error)")
                }
                
            }
            self.tableView.reloadData()
            
        }
        itemAddAlert.addTextField { (textField) in
            textField.placeholder = "Create a todo item"
            newTodoName = textField
            
        }
        
        itemAddAlert.addAction(action)
        present(itemAddAlert, animated: true)
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}
//MARK:- Search bar methods
extension TodoViewController:UISearchBarDelegate{
    
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            //this is done for refreshing the search list with all the items of selected Category
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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

