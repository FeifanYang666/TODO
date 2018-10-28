//
//  CategoryViewController.swift
//  TODO
//
//  Created by 杨非凡 on 2018/10/28.
//  Copyright © 2018 Feifan Yang. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCategories()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!TodoListViewController
        if segue.identifier == "goToItems" {
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories[indexPath.row]
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

    
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController (title: "添加新类别", message: "", preferredStyle: .alert)
        let action  = UIAlertAction (title: "添加", style: .default){
            (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField{
            (field) in
            textField = field
            textField.placeholder = "添加一个新类别"
        }
        present(alert, animated: true, completion: nil)
    }
    func saveCategories(){
        do {
            try context.save()
        }catch{
            print("save Category error:\(error)")
        }
        tableView.reloadData()
    }
    func loadCategories() {
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        }catch{
            print("load error:\(error)")
        }
        tableView.reloadData()
    }
    
}
