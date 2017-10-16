//
//  ViewController.swift
//  myCoreData
//
//  Created by cis290 on 10/16/17.
//  Copyright © 2017 Rock Valley College. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var btnedit: UIButton!
    
    @IBAction func btnedit(_ sender: UIButton) {
    
        name.isEnabled = true
        author.isEnabled = true
        genre.isEnabled = true
        btnsave.isHidden = false
        btnedit.isHidden = true
        name.becomeFirstResponder()
    }
    
    @IBAction func btnsave(_ sender: UIButton) {
    
        if (bookdb != nil)
        {
            
            bookdb.setValue(name.text, forKey: "name")
            bookdb.setValue(author.text, forKey: "author")
            bookdb.setValue(genre.text, forKey: "genre")
            
        }
        else
        {
            let entityDescription =
                NSEntityDescription.entity(forEntityName: "Book",in: managedObjectContext)
            
            let book = Book(entity: entityDescription!,
                                  insertInto: managedObjectContext)
            
            book.name = name.text!
            book.author = author.text!
            book.genre = genre.text!
        }
        var error: NSError?
        do
        {
            try managedObjectContext.save()
        }
        catch let error1 as NSError {
            error = error1
        }
        
        if let err = error {
            //if error occurs
           // status.text = err.localizedFailureReason
        } else {
            self.dismiss(animated: false, completion: nil)
            
        }
    }
    
    @IBAction func btnback(_ sender: UIButton) {
    
        self.dismiss(animated: false, completion: nil)

    }
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var bookdb:NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (bookdb != nil)
        {
            name.text = bookdb.value(forKey: "name") as? String
            author.text = bookdb.value(forKey: "author") as? String
            genre.text = bookdb.value(forKey: "genre") as? String
            btnsave.setTitle("Update", for: UIControlState())
            btnedit.isHidden = false
            name.isEnabled = false
            author.isEnabled = false
            genre.isEnabled = false
            btnsave.isHidden = true
        }else{
            btnedit.isHidden = true
            name.isEnabled = true
            author.isEnabled = true
            genre.isEnabled = true
        }
        name.becomeFirstResponder()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        if (touches.first as UITouch!) != nil {
            DismissKeyboard()
        }
    }
    
    func DismissKeyboard(){
        name.endEditing(true)
        author.endEditing(true)
        genre.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
}



