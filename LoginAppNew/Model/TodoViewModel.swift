////
////  TodoViewModel.swift
////  LoginAppNew
////
////  Created by Shabuddin on 22/05/22.
////
//
//import Foundation
//
//class TodoViewModel: NSObject{
//    static var sharedInstance = TodoViewModel()
//    
////    var tasks : Results<Item>?
//
//    var tasks = [Item]()
//    
//    typealias CompletionHandler = () -> Void
//    
//    let realm = try! Realm()
//    
//    
//    func addNotes(item: Item, completion: CompletionHandler) {
//
//        do{
//            try realm.write{
//                realm.add(item)
//            }
//        }catch{
//            print("Error saving \(error)")
//
//        }
//        
//        completion()
//    }
//    
//    func loadItems(completion: CompletionHandler) {
//        self.realm.beginWrite()
//        
//        let savedItems = self.realm.objects(Item.self)
//        self.tasks.removeAll()
//        self.tasks.append(contentsOf: savedItems)
//        try! self.realm.commitWrite()
//        
//        completion()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
//
//    }
//    
//    func updateItem(id: String, title: String, note: String, completion: CompletionHandler){
//
//        
//        print("before saved Item")
//        guard let savedItems = realm.objects(Item.self).filter("uuid == %@", id).first else {return}
//        
//        do{
//            try! realm.write {
//                savedItems.title = title
//                savedItems.notes = note
//            }
//        }catch {
//            print("error updating")
//        }
//        
//        print(savedItems)
//        completion()
//    }
//    
//    func deleteItem(id:String, completion: CompletionHandler){
//         
//        guard let savedItems = realm.objects(Item.self).filter("uuid == %@", id).first else {return}
//            do{
//            try realm.write{
//                realm.delete(savedItems)
//                }
//            }catch{
//                print("Error Deleting Items,\(error)")
//            }
//        completion()
//    }
//    
//}
