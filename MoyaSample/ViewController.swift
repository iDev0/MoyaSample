//
//  ViewController.swift
//  MoyaSample
//
//  Created by iDev0 on 2020/07/26.
//  Copyright © 2020 Ju Young Jung. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON


class ViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    
    var users = [User]()
    var userProvider = MoyaProvider<UserService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userProvider.request(.readUser) { (result) in
            switch result {
            case .success(let response):
                print(response.data)
                
                let users = try! JSONDecoder().decode([User].self, from: response.data)
                
                self.users = users
                
                OperationQueue.main.addOperation {
                    self.userTableView.reloadData()
                }
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    @IBAction func addUser(_ sender: Any) {
        userProvider.request(.createUser(name: "juyoung")) { (result) in
            switch result {
            case .success(let response):
                
                print(response.statusCode)
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }


}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // let id = indexPath.row
        
        userProvider.request(.detailUser(id: indexPath.row)) { (result) in
            switch result {
            case .success(let response):
                
                let jsonData = JSON(response.data)

                print(jsonData)
                
                let alertController = UIAlertController(title: jsonData["company"]["name"].string, message: jsonData["phone"].string, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                
                alertController.addAction(action)
                
                self.present(alertController, animated: true, completion: nil)
                
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // delete
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { (action, view, handler) in
            //
            
            self.userProvider.request(.deleteUser(id: indexPath.row)) { (result) in
                switch result {
                case .success(let response):
                    
                    print(response.statusCode)
                    
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
            
            
            handler(true)
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        
        
        return swipeAction
    }
    
    
}

