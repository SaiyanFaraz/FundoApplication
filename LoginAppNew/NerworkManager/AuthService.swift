//
//  AuthService.swift
//  LoginAppNew
//
//  Created by Shabuddin on 13/05/22.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthService{
    
   static let shared = AuthService()
    
    private init() {}
    
    func loginUser(email: String, password: String, completed : AuthDataResultCallback?)  {
//        Auth.auth().signIn(withEmail: email, password: password, completion : completed )
        Auth.auth().signIn(withEmail: email, password: password, completion: completed)
        
    }
    
    func createUser(email: String, password: String, completed: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completed)
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()

        } catch {
            print("Could Not signout")
        }
    }
}
