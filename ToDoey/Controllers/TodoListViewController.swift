//
//  TodoListViewController.swift
//  ToDoey
//
//  Created by Mahmoud El-Melligy on 10/23/19.
//  Copyright © 2019 Mahmoud El-Melligy. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController : UITableViewController{
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    var itemArray = [Items]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //        let newItem = Item()
        //        newItem.title = "Find Mike"
        //        itemArray.append(newItem)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "Buy Eggos"
        //        itemArray.append(newItem2)
        //
        //        let newItem3 = Item()
        //        newItem3.title = "Destroy Demogorgon"
        //        itemArray.append(newItem3)
        
        //user defaults
        //        if let items = defaults.array(forKey: "TodolistArray") as? [Item]{
        //            itemArray = items
        //        }
    }
    
    //MARK: - tableview Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==> value = condition ? valueifTure : valueIfFalse
        //de bas zai kol al maktob tahteha :D
        cell.accessoryType = item.done ? .checkmark : .none
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    
    //MARK:- tableview Deleget Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        
        //        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        // de bas zai kol al maktob tahteha :D
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        //       if itemArray[indexPath.row].done == false{
        //            itemArray[indexPath.row].done = true
        //        }else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK:- Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our alert
            //NScodeing
            //            let newItem = Item()
            //i will make it globle varbule
            //            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newItem = Items(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK :- Model Manupulation Methods
    
    func saveItems() {
        //        let encoder = PropertyListEncoder()
        
        do{
            //            let data = try encoder.encode(itemArray)
            //            try data.write(to: dataFilePath!)
            try context.save()
        }catch{
            //            print("Error encoding item array, \(error)")
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Items> = Items.fetchRequest(),predicate : NSPredicate? = nil ){
        //        let request : NSFetchRequest<Items> = Items.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        //        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
        //        request.predicate = compoundPredicate
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context, \(error)")
        }
        //decoder encoder fetching data
        //        if let data = try? Data.init(contentsOf: dataFilePath!){
        //            let decoder = PropertyListDecoder()
        //            do{
        //            itemArray = try decoder.decode([Item].self, from: data)
        //            }catch{
        //                print("Error decoding item array, \(error)")
        //            }
        //        }
        
    }
    
}

//MARK :- search Bar delegate and methods
extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Items> = Items.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        //        do{
        //            itemArray = try context.fetch(request)
        //        }catch{
        //            print("Error fetching data from context, \(error)")
        //        }
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
        }
    }
    
    
}
