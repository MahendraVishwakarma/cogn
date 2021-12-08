//
//  PostsModel.swift
//  Mahendra
//

//  Copyright © 2021 Mahendra. All rights reserved.
//

import Foundation
class PostsModel:Codable, Identifiable {
    let userID:Int
    let id: Int
    var isFavourite:Bool = false
    let titleDescription, bodyDescription: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case bodyDescription = "body"
        case titleDescription = "title"
        case id
    }
    
}
