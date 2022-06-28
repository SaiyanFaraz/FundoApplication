//
//  FireBaseNoteService.swift
//  CollectionViewCutomeCell
//
//  Created by Shabuddin on 25/05/22.
//
import UIKit
import Foundation
import Firebase

class FireBaseNoteService {
    // MARK: properties
    static let shared = FireBaseNoteService()
    
    var db = Firestore.firestore().collection("NotesData")
    var lastSnapshot: QueryDocumentSnapshot?
    private init() {}
    
    func fetchNotes(query: Query, completion: @escaping ([Note]?, Error?) -> Void ) {
        var notesArr = [Note]()
        query.getDocuments { snapshot, error in
            if error != nil {
                print("/(error)")
                completion(nil,error)
                
            } else {
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let id = dict["id"] as! String
                    let title = dict["title"] as! String
                    let description = dict["notes"] as! String
                    let reminder = dict["isReminder"] as! Bool
                    let archive = dict["isArchive"] as! Bool
                    
                    let note = Note(id: id, title: title, description: description, isReminder: reminder, isArchive: archive)
                    
                    notesArr.append(note)
                    
                })
                self.lastSnapshot = snapshot?.documents.last
                completion(notesArr,nil)
            }
        }
    }
    
    func fetchInitialNotes (completion: @escaping ([Note]?, Error?) -> Void ) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let query = db.document(userId).collection("Notes").whereField("isArchive", isEqualTo: false).limit(to: 13)
        fetchNotes(query: query, completion: completion)
    }
    
    func fetchMoreNotes(completion: @escaping ([Note]?, Error?) -> Void ) {
        print("------inside Fetch More Notes-----")
        if lastSnapshot != nil {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let query = db.document(userId).collection("Notes").whereField("isArchive", isEqualTo: false).limit(to: 13).start(afterDocument: lastSnapshot!)
            fetchNotes(query: query, completion: completion)
        }
    }
    
    func fetchInitialArchiveNotes (completion: @escaping ([Note]?, Error?) -> Void ) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let query = db.document(userId).collection("Notes").whereField("isArchive", isEqualTo: true).limit(to: 13)
        fetchNotes(query: query, completion: completion)
    }
    
    func fetchMoreArchiveNotes(completion: @escaping ([Note]?, Error?) -> Void ) {
        if lastSnapshot != nil {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let query = db.document(userId).collection("Notes").whereField("isArchive", isEqualTo: true).limit(to: 13).start(afterDocument: lastSnapshot!)
            fetchNotes(query: query, completion: completion)
        }
    }
    
    func fetchInitialReminderNotes (completion: @escaping ([Note]?, Error?) -> Void ) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let query = db.document(userId).collection("Notes").whereField("isReminder", isEqualTo: true).limit(to: 13)
        fetchNotes(query: query, completion: completion)
    }
    
    func fetchMoreReminderNotes(completion: @escaping ([Note]?, Error?) -> Void ) {
        if lastSnapshot != nil {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let query = db.document(userId).collection("Notes").whereField("isReminder", isEqualTo: true).limit(to: 13).start(afterDocument: lastSnapshot!)
            fetchNotes(query: query, completion: completion)
        }
    }
    
    
    func updateNote(id: String, title: String, description: String, isReminder: Bool, archive: Bool) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.document(userId).collection("Notes").getDocuments { [self] snapshot, error in
            if error != nil{
                print("error")
                return
            }
            snapshot?.documents.forEach({ element in
                print(element.data()["id"] as! String)
                
                let documentId = element.data()["id"] as! String
                
                if id == documentId {
                    print(element.data()["id"] as! String)
                    
                    db.document(userId).collection("Notes").document(element.documentID).setData(["title": title, "notes": description, "isArchive": archive, "isReminder": isReminder], merge: true)
                }
            })
        }
    }
    
    func deleteNote(id: String, title: String, description: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.document(userId).collection("Notes").getDocuments { [self] snapshot, error in
            
            if error != nil{
                print("error")
                return
            } else {
                snapshot?.documents.forEach({ element in
                    print(element.data()["id"] as! String)
                    
                    let documentId = element.data()["id"] as! String
                    
                    if id == documentId {
                        print(element.data()["id"] as! String)
                        db.document(userId).collection("Notes").document(element.documentID).delete()
                    }
                })
            }
        }
    }
    
    func addNote(note: Note,  completion: @escaping ()-> Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.document(userId).collection("Notes").addDocument(data: ["id": note.id, "title": note.title, "notes": note.description, "isReminder": note.isReminder, "isArchive": note.isArchive]) { error in
            if let err = error {
                print("Error Adding the document: \(err.localizedDescription)")
            } else {
                print("Added data")
                
                completion()
            }
        }
        
    }
}


