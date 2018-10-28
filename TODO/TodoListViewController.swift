//
//  ViewController.swift
//  TODO
//
//  Created by 杨非凡 on 2018/10/27.
//  Copyright © 2018 Feifan Yang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
var  itemArray = ["写代码","学高数","记单词"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell",for:indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController (title: "添加一个新的ToDo项目", message: " ", preferredStyle: .alert)
        let action = UIAlertAction (title: "添加项目", style: .default){
            (action) in
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
            print(textField.text!)
        }
        alert.addTextField(configurationHandler: {(alertTextField) in
            alertTextField.placeholder = "创建一个新的项目..."
            textField = alertTextField
        })
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
}

