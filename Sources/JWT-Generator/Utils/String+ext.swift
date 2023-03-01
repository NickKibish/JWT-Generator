//
//  File.swift
//  
//
//  Created by Nick Kibysh on 28/02/2023.
//

import Foundation

extension String {
    struct RegEx {
        static let authKeyFile = "^AuthKey_\\w+\\.p8$"
        static let keyId = "(?<=AuthKey_)[a-zA-Z0-9]+(?=.p8)"
    }
    
    func isMatchPattern(_ pattern: String) -> Bool {
        return self.range(of: pattern, options: .regularExpression) != nil
    }
    
    var keyId: String? {
        if let match = self.range(of: String.RegEx.keyId, options: .regularExpression) {
            let stringIndex = self[match]
            let keyId = String(stringIndex)
            
            return keyId
        } else {
            return nil
        }
        
    }
}
