//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by mahmoud el melligy on 11/5/19.
//  Copyright © 2019 Mahmoud El-Melligy. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
    }
    
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row].name
        
        cell.textLabel?.text = category
        
        return cell
    }
    
    
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
       if let indexPath = tableView.indexPathForSelectedRow{
        destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK :- Model Manupulation Methods
    func saveCategory() {
        
        do{
            try context.save()
        }catch{
            print("Error saving Catagory, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error fetching data from Catagory context, \(error)")
        }
        tableView.reloadData()
    }
    
}

