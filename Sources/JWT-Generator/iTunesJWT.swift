//
//  File.swift
//  
//
//  Created by Nick Kibysh on 27/02/2023.
//

import Foundation
import SwiftJWT

struct iTunesJWTPayload: Claims {
    var iss: String
    var iat = Date()
    var exp = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 10 * 60)
    var aud = "appstoreconnect-v1"
}

struct iTunesJWT {
    let header: Header
    let payload: iTunesJWTPayload
    
    init(kid: String, iss: String) {
        self.payload = iTunesJWTPayload(iss: iss)
        self.header = Header(typ: "JWT", kid: kid)
    }
    
    func jwt(privateKey: Data) throws -> String {
        let jwtSigner = JWTSigner.es256(privateKey: privateKey)
        var jwt = SwiftJWT.JWT<iTunesJWTPayload>(header: header, claims: payload)
        return try jwt.sign(using: jwtSigner)
    }
}
