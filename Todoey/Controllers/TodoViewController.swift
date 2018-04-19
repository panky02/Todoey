//
//  ViewController.swift
//  Todoey
//
//  Created by Pankaj Kumar on 16/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {

    var itemArray = [Item]()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    
    //as we are using the entire UITableViewController so we donot see any delegate or datasource methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }

    //MARK - Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
    
        tableView.deselectRow(at: indexPath, animated: true)
        
//        managedContext.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()
    }
    
    //MARK - add new item button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newTodoName = UITextField()
        let itemAddAlert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this part handles what should happen after clicking on add item button in Alert
            
            let addTodoItem = Item(context: self.managedContext)
            
            addTodoItem.title = newTodoName.text!
            addTodoItem.done = false
            self.itemArray.append(addTodoItem)
            self.saveItems()
         
        }
        itemAddAlert.addTextField { (textField) in
            textField.placeholder = "Create a todo item"
            newTodoName = textField
          
        }
        
        itemAddAlert.addAction(action)
        present(itemAddAlert, animated: true)
    }
    

    func saveItems(){
        
        
        do{
           try managedContext.save()
        } catch {
            print("some error occured in context \(error)")
        }
        tableView.reloadData()
    }
    
    //the loadItems function can now be called with or without a request parameter
    func loadItems( with request: NSFetchRequest<Item> = Item.fetchRequest()){
        
        //let request:NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try managedContext.fetch(request)
        } catch {
            print("error ocurred while reading data \(error)")
        }
        tableView.reloadData()
    }

}
//MARK:- Search bar methods
extension TodoViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request :NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
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

