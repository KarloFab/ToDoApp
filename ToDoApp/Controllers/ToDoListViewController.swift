//
//  ViewController.swift
//  ToDoApp
//
//  Created by Karlo Fabijanić on 13.12.2021..
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
          loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done.toggle()
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error occured while saving item: \(error)")
                }
            }
            
            self.tableView.reloadData()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
    }
    

    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }

    override func updateModel(at indexPath: IndexPath) {
        if let itemToBeDeleted = self.items?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToBeDeleted)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }

}

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
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

