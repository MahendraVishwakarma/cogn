//
//  PostsViewModel.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 07/03/21.
//  Copyright © 2021 Mahendra. All rights reserved.
//

import Foundation
class PostsModelView {
    var posts: [PostsModel]?
    func getPostData(isPrice:String?) {
       
        let requestURL  = "https://jsonplaceholder.typicode.com/posts"
    
        WebServices.requestHttp(urlString: requestURL, method: .Get, param: nil, decode: { (json) -> [PostsModel]? in
            guard let response = json as? [PostsModel] else{
                return nil
            }
            return response
            
        }) { [weak self] (result) in
            
            switch result {
            case .success(let response) :
                if let data = response {
                    self?.posts = data
                }
                break
            case .failure(let error) :
                print(error.localizedDescription)
                
                break
            }
            
        }
    }
}
