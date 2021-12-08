//
//  PostsViewModel.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 07/03/21.
//  Copyright © 2021 Mahendra. All rights reserved.
//

import Foundation
import Action
import RxSwift
import Realm
import RealmSwift

protocol DashboardViewModelInput: BaseViewModelInput {
    var getDashboardDataAPI: CocoaAction { get }
}
protocol DashboardViewModelOuput: BaseViewModelOuput {
   
}
protocol DashboardViewModelType {
  var inputs: DashboardViewModelInput { get }
  var outputs: DashboardViewModelOuput { get }
}

class PostsViewModel: BaseViewModel, DashboardViewModelInput, DashboardViewModelOuput, DashboardViewModelType {
    
    var inputs: DashboardViewModelInput { return self }
    var outputs: DashboardViewModelOuput { return self }
    
    var posts: [StoredPost]?
    var favouritePosts: Results<StoredPost>!
    var realm: Realm!
    
    lazy var getDashboardDataAPI: CocoaAction = {
        CocoaAction { [unowned self] _ in
            return self.getPostData()
        }
    }()
    override init() {
        self.realm = try! Realm()
        self.favouritePosts = self.realm.objects(StoredPost.self).filter("isFavourite = %i", NSNumber(booleanLiteral: true))
    }
    
    func fetchStoredData() {
        self.favouritePosts = self.realm.objects(StoredPost.self).filter("isFavourite = %i", NSNumber(booleanLiteral: true))
    }
    func getPostData() -> Observable<Void>  {
       let requestURL  = "https://jsonplaceholder.typicode.com/posts"
        let data = self.realm.objects(StoredPost.self)
        if data .count > 0 {
            
            self.posts =  Array(data)
            self.baseStateProperty.onNext(.finished)
        }
        
        
        self.baseStateProperty.onNext(.loading)
           WebServices.requestHttp(urlString: requestURL, method: .Get, param: nil, decode: { (json) -> [StoredPost]? in
               guard let response = json as? [StoredPost] else{
                   return nil
               }
               return response
               
           }) {(result) in
               
               switch result {
               case .success(let response) :
                   if let data = response {
                    DispatchQueue.main.async {
                        self.posts = data
                        try? self.realm.write{
                            self.realm.add(data, update: .all)
                        }
                    }
                     
                   }
                   
                  
                   self.baseStateProperty.onNext(.finished)
               case .failure(let error) :
                   print(error.localizedDescription)
                  break
               }
               
           }
        return .empty()
    }
}
