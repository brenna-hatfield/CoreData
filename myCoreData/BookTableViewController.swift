//
//  BookTableViewController.swift
//  myCoreData
//
//  Created by cis290 on 10/16/17.
//  Copyright © 2017 Rock Valley College. All rights reserved.
//
import UIKit
import CoreData
import Foundation
class BookTableViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    var filteredTableData = [NSManagedObject]()
    var resultSearchController = UISearchController()
    var bookArray = [NSManagedObject]()
    
    func updateSearchResults(for searchController: UISearchController)
    {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (bookArray as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [NSManagedObject]
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    
    func loaddb()
    {
        let managedContext = (UIApplication.shared.delegate
            as! AppDelegate).persistentContainer.viewContext

        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Book")
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                bookArray = results
                tableView.reloadData()
            } else {
                print("Could not fetch")
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription),\(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultSearchController.delegate = self
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.delegate = self
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive) {
            return filteredTableData.count
        }
        else {
            return bookArray.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if (self.resultSearchController.isActive) {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell")
                    as UITableViewCell!
            let person = filteredTableData[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "name") as! String?
            cell?.detailTextLabel?.text = ">>"
            return cell!
        }
        else {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell")
                    as UITableViewCell!
            let person = bookArray[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "name") as! String?
            cell?.detailTextLabel?.text = ">>"
            return cell!
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You selected cell #\((indexPath as NSIndexPath).row)")
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate
                as! AppDelegate).persistentContainer.viewContext
            if (self.resultSearchController.isActive) {
                context.delete(filteredTableData[(indexPath as NSIndexPath).row])
            }
            else {
                context.delete(bookArray[(indexPath as NSIndexPath).row])
            }
            
            var error: NSError? = nil
            do {
                try context.save()
                loaddb()
            } catch let error1 as NSError {
                error = error1
                print("Unresolved error \(String(describing: error))")
                abort()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UpdateBooks" {
            if let destination = segue.destination as?
                ViewController {
                if (self.resultSearchController.isActive) {
                    if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                        let selectedDevice:NSManagedObject = filteredTableData[SelectIndex] as NSManagedObject
                        destination.bookdb = selectedDevice
                        resultSearchController.isActive = false
                    }
                }
                else {
                    if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                        let selectedDevice:NSManagedObject = bookArray[SelectIndex] as NSManagedObject
                        destination.bookdb = selectedDevice
                    }
                }
            }
        }
    }
}








