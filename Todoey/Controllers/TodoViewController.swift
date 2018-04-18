//
//  ViewController.swift
//  Todoey
//
//  Created by Pankaj Kumar on 16/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    var itemArray = [Item]()
    //var itemArray = ["buy apples","buy groceries","buy something","n","o","p","k","l","h","q","w","e","r","t","y","u","i","o","v"]
    //let defaults = UserDefaults.standard
    
    //Nscode method to save User defined data in plist
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //as we are using the entire UITableViewController so we donot see any delegate or datasource methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let newItem = Item()
//        newItem.title = "buy apples"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "buy groceries"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "buy something"
//        itemArray.append(newItem3)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        
        loadData()
        
        //print(dataFilePath)
    }

    //MARK - Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //ternary Operator substitute for below if else code
        // value = condition ? value if true : value if False
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true{
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

       saveItems()
        
        //the below if else code was creating error when we were scrolling our table view as it was being reused
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
    }
    
    //MARK - add new item button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newTodoName = UITextField()
        let itemAddAlert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this part handles what should happen after clicking on add item button in Alert
            let addTodoItem = Item()
            addTodoItem.title = newTodoName.text!
            self.itemArray.append(addTodoItem)
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
//            let encoder = PropertyListEncoder()
//            do{
//            let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            } catch {
//                print("some error occureed during encoding \(error)")
//            }
//            self.tableView.reloadData()
        }
        itemAddAlert.addTextField { (textField) in
            textField.placeholder = "Create a todo item"
            newTodoName = textField
          
        }
        
        itemAddAlert.addAction(action)
        present(itemAddAlert, animated: true)
    }
    

    func saveItems(){
        
        let encoder = PropertyListEncoder()
        do{
        let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("some error occured during encoding \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
             itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("some error while decoding \(error)")
            }
        }
    }
}

