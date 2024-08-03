//
//  Validator.swift
//  Task
//
//  Created by Kyriakos Lingis on 14/11/2023.
//

import Foundation

protocol Validator {
    
    func isValid(_ validator: (String) -> Bool,
                 input: String) throws -> Bool
    
    func execute(_ validation: (String) -> Bool,
                 input: String) -> Bool
    
}
