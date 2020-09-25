//
//  PostsViewController.swift
//  ThePosts
//
//  Created by Антон on 21.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    
    let titleFilterChoise = UILabel()
    let sections = ["mostPopular", "mostCommented", "createdAt"]
    lazy var filterChoice: UISegmentedControl = {
        let control = UISegmentedControl(items: sections)
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        return control
    }()
    let spinner = UIActivityIndicatorView()
    var isLoading = true
    var tableView = UITableView()
    
    var typeSorted: Int?
    var postManager = PostManager()
    var posts = [PostModel]()
    var currentCursor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        postManager.getLatestPosts(name: "") { (posts, cursor) in
            self.currentCursor = cursor
            print("\(self.currentCursor) - in viewDidLoad")
            self.posts += posts
            self.tableView.reloadData()
        }
    }
    
    @objc func segmentControl(_ segmentControl: UISegmentedControl) {
        
        postManager.getLatestPosts(name: setupSortedName(object: segmentControl.selectedSegmentIndex)) { (posts, cursor) in
            self.posts = []
            self.posts = posts
            self.currentCursor = cursor
            self.tableView.reloadData()
        }
    }
    
    func setupSortedName(object: Int) -> String {
        switch object {
        case 0:
            typeSorted = 0
            return postManager.filteredBy(.mostPopular).0
        case 1:
            typeSorted = 1
            return postManager.filteredBy(.mostCommented).0
        case 2:
            typeSorted = 2
            return postManager.filteredBy(.createdAt).0
        default:
            break
        }
        return ""
    }
    
    func setupViews() {
        
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.831372549, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.831372549, alpha: 1)
        
        view.addSubview(titleFilterChoise)
        titleFilterChoise.translatesAutoresizingMaskIntoConstraints = false
        titleFilterChoise.text = "Sorted by..."
        titleFilterChoise.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleFilterChoise.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(filterChoice)
        filterChoice.translatesAutoresizingMaskIntoConstraints = false
        filterChoice.topAnchor.constraint(equalTo: titleFilterChoise.bottomAnchor).isActive = true
        filterChoice.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.7882352941, blue: 0.5333333333, alpha: 1)
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: filterChoice.bottomAnchor, constant: 10).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(spinner)
        spinner.style = .large
        spinner.color = .white
        spinner.center = view.center
        spinner.hidesWhenStopped = true
    }
    
}

//MARK: - UITableViewDelegate methods

extension PostsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        if posts.count != 0 {
            let post = posts[indexPath.item]
            detailVC.currentPost = post
            navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if isLoading == false {
                spinner.startAnimating()
                currentCursor = postManager.cursorString
                isLoading = true
                    if currentCursor != nil {
                        var fullName = ""
                        if typeSorted != nil {
                            fullName = setupSortedName(object: typeSorted!) + "&after=\(currentCursor!)"
                        } else {
                            fullName = "?after=\(currentCursor!)"
                        }
                            print("\(self.currentCursor) - in scrollViewDidEndDragging")
                            postManager.getLatestPosts(name: fullName) { (posts, cursor) in
                                self.posts += posts
                                self.tableView.reloadData()
                                //   self.currentCursor = cursor
                                self.spinner.stopAnimating()
                            }
                        }
                    }
            } else {
                isLoading = false
                return
            }
        }
        
    }

//MARK: - UITableViewDataSource methods

extension PostsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.7882352941, blue: 0.5333333333, alpha: 1)
        
        let post = posts[indexPath.row]
        cell.setupCell(with: post)
        
        return cell
    }
    
    
}
