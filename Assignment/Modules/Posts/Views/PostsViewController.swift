//
//  PostsViewController.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 07/03/21.
//  Copyright © 2021 Mahendra. All rights reserved.
//

import UIKit

class PostsViewController: BaseViewController, BindableType {
    

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var postTableView: UITableView!
    var viewModel:PostsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
       
    }
    
    private func setup() {
        viewModel = PostsViewModel()
        viewModel.inputs.getDashboardDataAPI.execute()
        postTableView.dataSource = self
        postTableView.register(UINib(nibName: String(describing: PostsCell.self), bundle: nil), forCellReuseIdentifier: PostsCell.identifier)
        postTableView.tableFooterView = UIView(frame: .zero)
        bindViewModel()
    }
    func bindViewModel() {
        _ = viewModel.inputs
        let outputs = viewModel?.outputs
        outputs?.baseStateObservable.asObservable().subscribe(onNext: { [unowned self](state) in
            switch state {
            case .notLoad, .loading:
                 self.stopLoader()
                
            case .finished:
                self.setData()
                self.stopLoader()
            case .failed:
                self.stopLoader()
                
            }
        }).disposed(by: disposeBag)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //viewModel.fetchStoredData()
        postTableView.reloadData()
        
    }
    private func stopLoader() {
        DispatchQueue.main.async {
          self.loader.stopAnimating()
        }
          
    }
    private func setData() {
        DispatchQueue.main.async {
            self.postTableView.reloadData()
        }
    }
}

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.posts?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsCell.identifier, for: indexPath) as? PostsCell else {
            return UITableViewCell()
        }
        
    
        cell.btnAction.tag = indexPath.row
        
        if let post = viewModel?.posts?[indexPath.row] {
            if viewModel.favouritePosts.contains(post) {
                cell.btnAction.setImage(UIImage(named: "favourites"), for: .normal)
            }else{
                 cell.btnAction.setImage(UIImage(named: "unfav"), for: .normal)
            }
            cell.headingLabel.text = post.titleDescription
            cell.descriptionLabel?.text = post.bodyDescription
            
            cell.btnAction.addTarget(self, action: #selector(makeFavourite(sender:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func makeFavourite(sender:UIButton) {
       
        try! viewModel?.realm.write {
            if let post = viewModel?.posts?[sender.tag] {
                post.isFavourite  = !(post.isFavourite)
                self.viewModel.realm.add(post, update: .all)
                self.postTableView.reloadData()
            }
            
           
        }
        
    }
}
