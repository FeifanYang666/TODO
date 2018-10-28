//
//  ViewController.swift
//  TODO
//
//  Created by 杨非凡 on 2018/10/27.
//  Copyright © 2018 Feifan Yang. All rights reserved.
//
import UIKit
import CoreData
class TodoListViewController: UITableViewController {
    var selectedCategory:Category? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    //MARK: - Table View DataSource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // print("更新第：\(indexPath.row)行")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        //    if item.done == false {
        //      cell.accessoryType = .none
        //    }else {
        //      cell.accessoryType = .checkmark
        //    }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Table View Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row )
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        let title  = itemArray[indexPath.row].title
        itemArray[indexPath.row].setValue(title!, forKey: "title")
        saveItems()
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加一个新的ToDo项目", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "添加项目", style: .default) { (action) in
            // 当用户点击添加项目按钮以后要执行的代码
            
//            let newItem = Item()
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "创建一个新项目..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItems(){
     
        do{
            
            try context.save()
        }catch{
            print("error:\(error)")
        }
        tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil) {
        let categoryPredicate = NSPredicate (format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate (andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
          
        }else{
            request.predicate = categoryPredicate
        }
        do {
            itemArray = try context.fetch(request)
        }catch{
            print("error is \(error)")
        }
        tableView.reloadData()
    }
    
}

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        todoItems = todoItems?.filter("title CONTAINS[c] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        let request:NSFetchRequest<Item> = Item.fetchRequest()
    
        request.predicate = NSPredicate (format:"title CONTAINS[c] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor (key: "title", ascending: true)]
        loadItems()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
