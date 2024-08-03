//
//  Validations.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import Foundation

class Validations: Validator {
    func isValid(_ validator: (String) -> Bool, input: String) throws -> Bool {
        return execute(validator, input: input)
    }
    
    func execute(_ validation: (String) -> Bool, input: String) -> Bool {
        return validation(input)
    }
    
    //Validation Functions
    
    static func isUsernameValid(text: String) -> Bool {
        return text.lowercased().elementsEqual("tasker")
    }
    
    static func isPasswordValid(text: String) -> Bool {
        return text.elementsEqual("tasker123")
    }
}
