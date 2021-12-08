//
//  PostsModel.swift
//  Mahendra
//

//  Copyright © 2021 Mahendra. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class StoredPost: Object, Decodable {
    dynamic var id: Int = 0
    dynamic var isFavourite: Bool = false
    dynamic var userID: Int = 0
    dynamic var titleDescription: String = ""
    dynamic var bodyDescription:String = ""
    
   enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case bodyDescription = "body"
        case titleDescription = "title"
        case id
    }
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        userID = try container.decode(Int.self, forKey: .userID)
       
        titleDescription = try container.decode(String.self, forKey: .titleDescription)
        bodyDescription = try container.decode(String.self, forKey: .bodyDescription)
                    
        
        super.init()
    }
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    required override init()
    {
        super.init()
    }
    
}
