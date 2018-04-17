//
//  ViewController.swift
//  Todoey
//
//  Created by Pankaj Kumar on 16/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    var itemArray = ["buy apples","buy groceries","buy something"]
    //as we are using the entire UITableViewController so we donot see any delegate or datasource methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
    
        tableView.deselectRow(at: indexPath, animated: true)
        

        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    //MARK - add new item button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newTodoName = UITextField()
        let itemAddAlert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this part handles what should happen after clicking on add item button in Alert
            print("newTodoName value \(newTodoName.text!)")
            print("success!")
            self.itemArray.append(newTodoName.text!)
            self.tableView.reloadData()
        }
        itemAddAlert.addTextField { (textField) in
            textField.placeholder = "create a todo item"
            newTodoName = textField
          
        }
        
        itemAddAlert.addAction(action)
        present(itemAddAlert, animated: true)
    }
    

}

