//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pankaj Kumar on 19/04/18.
//  Copyright © 2018 Pankaj Kumar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let categoryContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    //MARK:- TableView Datsource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        //what to show in Table view reuable Cell
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK:- Data Manipulation Methods
    func saveCategory() {
        
        do{
        try categoryContext.save()
        } catch {
            print("error while saving new category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try categoryContext.fetch(request)
        } catch{
            print("Error in fetching values \(error)")
        }
    }
    
    
    //MARK:- Add new Categories
    
    @IBAction func addCategroryBtnPressed(_ sender: UIBarButtonItem) {
        
        let categoryAlert = UIAlertController(title: "To Add New Category", message: "", preferredStyle: .alert)
        
        var categoryText = UITextField()
        
        let alertBtn = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //this Closure will be triggered when the Add Category btn is pressed
            print("Add category btn pressed with Text \(categoryText.text!)")
            
            let categoryItem = Category(context: self.categoryContext)
            categoryItem.name = categoryText.text!
            self.categoryArray.append(categoryItem)
            self.saveCategory()
            
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
        destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
}
