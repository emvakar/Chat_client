//
//  CHATModels.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import MessageKit

class CHATModelUser: NSObject, NSCoding, Codable {
    let id, nickname: String
    let isAdmin: Bool
    let email: String
    let updatedAt, createdAt: Date
    
    struct Payload: Codable {
        var id: String
        var email: String
        var nickname: String
        var isAdmin: Bool
    }
    
    init(from model: CHATSenderMessageAPIResponse) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.id = model.id
        self.nickname = model.nickname
        self.isAdmin = model.isAdmin
        self.email = model.email
        self.updatedAt = formatter.date(from: model.updatedAt) ?? Date(timeIntervalSince1970: 0)
        self.createdAt = formatter.date(from: model.createdAt) ?? Date(timeIntervalSince1970: 0)
    }
    
    init(id: String, nickname: String, isAdmin: Bool, email: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.nickname = nickname
        self.isAdmin = isAdmin
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(isAdmin, forKey: "isAdmin")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(createdAt, forKey: "createdAt")
        aCoder.encode(updatedAt, forKey: "updatedAt")
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        let nickname = aDecoder.decodeObject(forKey: "nickname") as? String ?? ""
        let isAdmin = aDecoder.decodeBool(forKey: "isAdmin")
        let email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        let createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date ?? Date(timeIntervalSince1970: 0)
        let updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date ?? Date(timeIntervalSince1970: 0)
        self.init(id: id, nickname: nickname, isAdmin: isAdmin, email: email, createdAt: createdAt, updatedAt: updatedAt)
        
    }
}
//struct User: Sender {
//
//    let id: String
//    let displayName: String
//    var avatar: UIImage?
//    var isSender: Bool = false
//
//    init(id: String, displayName: String) {
//        self.id = id
//        self.displayName = displayName
//        self.avatar = LetterImageGenerator.imageWith(name: id)
//        self.isSender = (UserDefaults.standard.string(forKey: DefaultsKeys.user_id) == id)
//    }
//
//    struct Payload: Codable {
//        var id: String?
//        var email, nickname: String
//    }
//}
