//
//  ViewController.swift
//  Dream Lister
//
//  Created by AADITYA NARVEKAR on 6/17/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController , UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var editLeftBarBtnItem: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attemptFetch()
//        generateTestdata()        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if tableView.numberOfRows(inSection: 0) > 0 {
            editLeftBarBtnItem.isEnabled = true
        } else {
            editLeftBarBtnItem.isEnabled = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DreamListerTableViewCell") as? DreamListerTableViewCell {
            configureCell(cell: cell, indexPath: indexPath)
            return cell
        } else {
            print("Error in dequeuing cell")
            return UITableViewCell()
        }
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        if let barBtn = sender as? UIBarButtonItem {
            if tableView.isEditing {
                tableView.setEditing(false, animated: true)
                barBtn.title = "Edit"
            } else {
                tableView.setEditing(true, animated: true)
                barBtn.title = "Done"
            }
        }        
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        editLeftBarBtnItem.title = "Done"
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        editLeftBarBtnItem.title = "Edit"
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultsController.object(at: indexPath)
            context.delete(item)
            appDelegate.saveContext()
        }
    }
    
    func configureCell(cell: DreamListerTableViewCell, indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        cell.configureCell(item: item)
    }

    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if let segment = sender as? UISegmentedControl {
            //let fetchedRequest: NSFetchRequest<Item> = Item.fetchRequest()
            var sortDescriptor: NSSortDescriptor! = nil
            switch segment.selectedSegmentIndex {
            case 0:
                sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
                break;
            case 1:
                sortDescriptor = NSSortDescriptor(key: "price", ascending: false)
                break;
            case 2:
                sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
                break;
            default:
                break;
            }
            if sortDescriptor != nil {
                fetchedResultsController.fetchRequest.sortDescriptors?.removeAll()
                fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
                do {
                    try fetchedResultsController.performFetch()
                    tableView.reloadData()
                } catch let err as NSError {
                    print("Error when performing sort: \(err.debugDescription)")
                }
            }
        }
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let err as NSError {
            print("Error performing fetch in Core Data: \(err.debugDescription)")
        }
    }
    
    // NSFetchedResultsController delegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // NSFetchedResultsController delegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // NSFetchedResultsController delegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let path = indexPath {
                tableView.deleteRows(at: [path], with: .fade)
            }
            break
        case .insert:
            if let path = newIndexPath {
                tableView.insertRows(at: [path], with: .fade)
            }
            break
        case .move:
            if let old = indexPath, let new = newIndexPath {
                if let cell = tableView.cellForRow(at: old) as? DreamListerTableViewCell {
                    configureCell(cell: cell, indexPath: new)
                    tableView.moveRow(at: old, to: new)
                }
            }
            break
        case .update:
            if let path = indexPath {
                if let cell = tableView.cellForRow(at: path) as? DreamListerTableViewCell {
                    configureCell(cell: cell, indexPath: path)
                    tableView.reloadRows(at: [path], with: .fade)
                } else {
                    print("Error in getting cell when attempting to update")
                }
            }
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Selected: \(indexPath.row)")
        let selectedItem = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "ItemDetailsVC", sender: selectedItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ItemDetailsVC else {
            return
        }
        
        if segue.identifier == "ItemDetailsVC" {
            if let item = sender as? Item {
                print("Loading details for item: \(item)")                
                destination.itemSelected = item
            }
            
        } else if segue.identifier == "ItemDetailsVCNew" {
            print("Add new item")
            destination.title = "New Item"
            destination.addNewItemOptionSelected = true
        } else {
            print("Incorrect segue initialized/prepared")
        }
    }
    
    func generateTestdata() {
        let item1 = Item(context: context)
        item1.title = "iMac"
        item1.price = 1500
        item1.details = "The new badass iMac Pro"
        
        let item2 = Item(context: context)
        item2.title = "iPad Pro"
        item2.price = 1000
        item2.details = "The iPad Pro with Apple pencil"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model 3"
        item3.price = 40000
        item3.details = "Can't wait to try out auto-pilot"
        
        
        appDelegate.saveContext()
        
    }
}

