//
//  AddNotesViewController.swift
//  LoginAppNew
//
//  Created by Shabuddin on 22/05/22.
// collection (NotesData)- > login usersID - > documentsId-> itmes

import UIKit
import UserNotifications

class AddNotesViewController: UIViewController {
            
    var note: Note?
    
    var saveNote = UIBarButtonItem()
    var transparentView = UIView()
    var reminderButton = UIBarButtonItem()
    var archiveButton = UIBarButtonItem()
    var datePicker = UIDatePicker()
    var date: Date?
    var isArchived = false
    var isReminder = false
    
    let reminderSaveButton: UIButton = {
        
        let reminderSavebtn = UIButton()
        reminderSavebtn.setTitle("Save", for: .normal)
        reminderSavebtn.backgroundColor = .gray
        
        return reminderSavebtn
    }()
    
    public var completion: ((String, String, String) -> Void)?
    
    var titleField: UITextField = {
        let title = UITextField()
        title.placeholder = "Please enter a title"
        title.borderStyle = .roundedRect
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .white
        title.layer.borderColor = UIColor.black.cgColor
        title.layer.borderWidth = 2
        title.layer.shadowOpacity = 1
        title.layer.shadowRadius = 3.0
        title.layer.shadowOffset = CGSize.zero
        title.layer.shadowColor = UIColor.gray.cgColor
        
        return title
    }()
    
    let notesField: UITextField = {
        let notes = UITextField()
        notes.placeholder = "Please enter notes"
        notes.borderStyle = .roundedRect
        notes.translatesAutoresizingMaskIntoConstraints = false
        notes.textAlignment = .natural
        notes.layer.borderColor = UIColor.black.cgColor
        notes.layer.borderWidth = 3
        notes.layer.shadowOpacity = 1
        notes.layer.shadowRadius = 3.0
        notes.layer.shadowOffset = CGSize.zero
        notes.layer.shadowColor = UIColor.gray.cgColor
        
        return notes
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
        
    func setUp() {
        guard let note = note else {return}

        titleField.text = note.title
        notesField.text = note.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addConstraints()
        setUp()
        
        archiveButton = UIBarButtonItem(image: UIImage(systemName: "archivebox.circle"), style: .done, target: self, action: #selector(handleArchive))
        reminderButton = UIBarButtonItem(image: UIImage(systemName: "bell.circle.fill"), style: .plain, target: self, action: #selector(addReminder))
        saveNote = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        
        navigationItem.rightBarButtonItems = [saveNote, archiveButton ,reminderButton]
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
    }
    @objc func handleArchive() {
        if note != nil {

            FireBaseNoteService.shared.updateNote(id: note!.id, title: titleField.text!, description: notesField.text!, isReminder: isReminder, archive: true)
            
        } else {
            
            let addNote = Note(id: UUID().uuidString, title: titleField.text!, description: notesField.text!, isReminder: isReminder, isArchive: true)
            FireBaseNoteService.shared.addNote(note: addNote) {
                return 
            }
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleDate() {

        date = datePicker.date
        
    }
    
    @objc func addReminder() {
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        datePicker.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 400)
        datePicker.minimumDate = Date()
        datePicker.setDate(Date(), animated: false)
        window?.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(handleDate), for: UIControl.Event.valueChanged)
        
        window?.addSubview(reminderSaveButton)
        
        reminderSaveButton.translatesAutoresizingMaskIntoConstraints = false
        reminderSaveButton.topAnchor.constraint(equalTo: datePicker.topAnchor, constant: 10).isActive = true
        reminderSaveButton.rightAnchor.constraint(equalTo: datePicker.rightAnchor, constant: -20).isActive = true
        
        reminderSaveButton.addTarget(self, action: #selector(handleReminderSave), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.datePicker.frame = CGRect(x: 0, y: screenSize.height - 400, width: screenSize.width, height: 400)
            
        }, completion: nil)        
    }
    
    @objc func onClickTransparentView() {
        let screenSize = UIScreen.main.bounds.size

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:{
            self.transparentView.alpha = 0
            self.datePicker.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 400)
            
        }, completion: nil)
        
    }
    
    @objc func handleReminderSave() {

        if let title = self.titleField.text,
           let description = self.notesField.text {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success{
                    self.isReminder = true
                    self.handelReminderNotification(title: title, description: description)
                } else if error != nil {
                    print("Error Occured")
                }
            }
        }
    }
    
    func handelReminderNotification(title: String, description: String) {
        
        if date != nil {
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.sound = .default
            content.body = description
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                        from: date!),
                                                        repeats: false)
        
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if error != nil {
                    print("something went wrong")
                }
            }
        }
    }
    
    @objc func saveTapped(){


        if note != nil {

            FireBaseNoteService.shared.updateNote(id: note!.id, title: titleField.text!, description: notesField.text!,isReminder: isReminder, archive: false)
            
        } else {
            
            let addNote = Note(id: UUID().uuidString, title: titleField.text!, description: notesField.text!, isReminder: isReminder, isArchive: false)
            
            FireBaseNoteService.shared.addNote(note: addNote) {

            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteTapped(){
        if note != nil {
            
            guard let note = note else {
                return
            }
            
            FireBaseNoteService.shared.deleteNote(id: note.id, title: titleField.text!, description: notesField.text!)
                self.navigationController?.popViewController(animated: true)

            }
        }

    func addConstraints() {
        view.addSubview(titleField)
        titleField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        titleField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleField.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        view.addSubview(notesField)
        notesField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 40).isActive = true
        notesField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        notesField.heightAnchor.constraint(equalToConstant: view.bounds.height/2).isActive = true
        notesField.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        view.addSubview(deleteButton)
        
        deleteButton.topAnchor.constraint(equalTo: notesField.bottomAnchor, constant: 40).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
}

extension Date {
    var localizedDescription: String {
        return description(with: .current)
    }
}
