//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Karlo Fabijanić on 09.01.2022..
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    
    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
    
        return cell
    }
    
    //MARK: - Data Manipulation methods
    
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("Error saving category: \(error)")
        }
    
        tableView.reloadData()
    }
    
    func loadCategories(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error retrieving data: \(error)")
        }
    
        tableView.reloadData()
    }
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context:self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
}
