//
//  AddNewNotesViewController.swift
//  TestApp
//
//  Created by HARDIK-SNEHAL on 2019-12-12.
//  Copyright © 2019 AlayaCare. All rights reserved.
//

import UIKit

class AddNewNotesViewController: UIViewController,UITextFieldDelegate {
    
    var store: NoteStore!
    
    @IBOutlet var noteTextField: UITextField!
    
    @IBAction func cancelNoteAction(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNoteAction(_ sender: UIBarButtonItem) {
     
        guard
            let noteToSave = noteTextField.text,
            !noteToSave.isEmpty else {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Enter some Note text to save.",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) {
                    (action) -> Void in
                }
                alertController.addAction(okAction)
                present(alertController,
                        animated: true,
                        completion: nil)
                return
        }
        
        let noteData = Note(noteDescription: noteTextField.text!, dateCreated: Date())
        
        var noteArray = [Note]()
        let noteStoredArray = Pref.note
        if let count = noteStoredArray?.count, count > 0 {
            noteArray += noteStoredArray!
        }
        noteArray.append(noteData)
        Pref.note = noteArray
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backGroundTap(_ sender: Any) {
        self.view.endEditing(true)
    }
 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
