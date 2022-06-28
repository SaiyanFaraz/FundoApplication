//
//  String + Extension.swift
//  LoginAppNew
//
//  Created by Shabuddin on 13/05/22.
//

import Foundation

extension String{
    func validateEmailId() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9._]+\\.[A-Za-z]{2,4}"
        return applyPredicateOnRegex(regexStr: emailRegEx)
    }
    
    func validatePassword(min: Int = 8, max: Int = 8 )-> Bool{
//        Minimum 8 characters at least 1 Alphabet and 1 Number
        var passRegEx = ""
        if min >= max{
            passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(min),}$"
        }else{
            passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(min)\(max)}$"
        }
        return applyPredicateOnRegex(regexStr: passRegEx)
    }
    
    func applyPredicateOnRegex(regexStr: String) -> Bool {
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validateOtherString = NSPredicate(format: "SELF MATCHES %@", regexStr)
        let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
        
        return isValidateOtherString
    }
}

