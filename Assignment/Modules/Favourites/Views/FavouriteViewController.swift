//
//  FavouriteViewController.swift
//  Assignment
//
//  Created by Mahendra Vishwakarma on 07/03/21.
//  Copyright © 2021 Mahendra. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController {

    @IBOutlet weak var favouriteTableView: UITableView!
    var viewModel:FavViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
         setup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         fetchUpdatedData()
    }
    
    private func fetchUpdatedData() {
        viewModel?.postViewModel.fetchStoredData()
        favouriteTableView.reloadData()
    }
    
    private func setup() {
        viewModel = FavViewModel()
        viewModel?.postViewModel.inputs.getDashboardDataAPI.execute()
        favouriteTableView.dataSource = self
        favouriteTableView.register(UINib(nibName: String(describing: PostsCell.self), bundle: nil), forCellReuseIdentifier: PostsCell.identifier)
        favouriteTableView.tableFooterView = UIView(frame: .zero)
       
    }

}

extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.postViewModel
            .favouritePosts.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsCell.identifier, for: indexPath) as? PostsCell else {
            return UITableViewCell()
        }
        
    
        cell.btnAction.tag = indexPath.row
        
        if let post = viewModel?.postViewModel.favouritePosts[indexPath.row] {
            if post.isFavourite {
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
       
        try! viewModel?.postViewModel.realm.write {
            if let post = viewModel?.postViewModel.favouritePosts[sender.tag] {
                post.isFavourite  = !(post.isFavourite)
                self.viewModel?.postViewModel.realm.add(post, update: .all)
                self.fetchUpdatedData()
            }
            
           
        }
        
    }
}

