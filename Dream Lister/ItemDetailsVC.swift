//
//  ItemDetailsVC.swift
//  Dream Lister
//
//  Created by AADITYA NARVEKAR on 6/28/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var itemTitle: CustomTextField!
    @IBOutlet weak var itemPrice: CustomTextField!
    @IBOutlet weak var itemDetails: CustomTextField!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var saveItemBtn: UIButton!
    @IBOutlet weak var selectedImage: UIImageView!
    
    
    var imagePicker: UIImagePickerController!
    
    var addNewItemOptionSelected: Bool = false
    var itemSelected: Item? = nil
    
    var selectedStore: Store!
    
    var stores: [Store]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTap()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)            
        }
                
        storePicker.delegate = self
        storePicker.dataSource = self
        
        itemTitle.delegate = self
        itemPrice.delegate = self
        itemDetails.delegate = self
        
        attemptFetchingStores()
        
        if !addNewItemOptionSelected {
            updateItemDetails()
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.image = img
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func updateImageBtnTapped(_ sender: Any) {
        print("Update Image Button Tapped")
        present(imagePicker, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let name = stores[row].name {
            return name
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component > 0 {
            selectedStore = stores[component]
        }
    }
    
    func attemptFetchingStores() {
        let storeFetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        storeFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            stores = try context.fetch(storeFetchRequest)
            storePicker.reloadAllComponents()
        } catch let err as NSError {
            print("Error fetching stores: \(err.debugDescription)")
        }
        
        if stores.count == 1 {
            generateStoresData()
        }
    }
    
    func generateStoresData() {
        let states: [String]! = ["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]
        
        for state in states {
            let store = Store(context: context)
            store.name = state
            stores.append(store)
        }
        appDelegate.saveContext()
        storePicker.reloadAllComponents()
    }
    
    @IBAction func saveItemBtnTapped(_ sender: Any) {
        
        guard !areTextFieldsEmpty()  else {
            print("Required fields are not populated")
            return
        }
        
        var item: Item!
        if addNewItemOptionSelected {
            item = Item(context: context)
        } else {
            if let selected = itemSelected {
                item = selected
                item.created = NSDate()
            } else {
                print("Error identifying the item to update")
            }
        }
        
        if let title = itemTitle.text {
            item.title = title
        }
        if let priceText = itemPrice.text, let price = Double(priceText) {
            item.price = price
        }
        if let details = itemDetails.text {
            item.details = details
        }
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        if let img = selectedImage.image {
            let image = Image(context: context)
            image.image = img
            item.toImage = image
        }
        
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            textField.text = textField.text?.replacingOccurrences(of: "$ ", with: "")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text?.characters.count == 0 {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.placeholder = "Required..."
            return false
        }
        textField.layer.borderColor = UIColor.clear.cgColor
        
        switch textField.tag {
        case 0:
            itemTitle.resignFirstResponder()
            itemPrice.becomeFirstResponder()
            break;
        case 1:
            itemPrice.resignFirstResponder()
            itemDetails.becomeFirstResponder()
            break;
        case 2:
            itemDetails.resignFirstResponder()
            break;
        default:
            print("Incorrect tag returned for text field.")
            return false
        }
        return true
    }
    
    private func areTextFieldsEmpty() -> Bool {
        return itemPrice.text?.characters.count == 0 || itemDetails.text?.characters.count == 0 || itemTitle.text?.characters.count == 0
    }
    
    private func updateItemDetails() {
        if let title = itemSelected?.title {
            itemTitle.text = title
            self.navigationItem.title = title
        } 
        
        if let desc = itemSelected?.details {
            itemDetails.text = desc
        }
        
        if let price = itemSelected?.price {
            itemPrice.text = "$ \(price)"
        }
        
        if let store = itemSelected?.toStore {
            let index = stores.index(of: store)
            storePicker.selectRow(index!, inComponent: 0, animated: true)
        }
        
        if let img = itemSelected?.toImage?.image as? UIImage {
            selectedImage.image = img
        }
        
    }
    
    @IBAction func trashBtnTapped(_ sender: Any) {
        if addNewItemOptionSelected {
            navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to permenantly delete this wish list item?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                if let item = self.itemSelected {
                    context.delete(item)
                    appDelegate.saveContext()
                    self.navigationController?.popViewController(animated: true)
                }
            })
                                    
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: false, completion: nil)
        }
    }
    

}
