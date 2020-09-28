//
//  PostsViewController.swift
//  ThePosts
//
//  Created by Антон on 21.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    
    //MARK: - Create UI Elements
    
    let titleFilterChoise = UILabel()
    lazy var filterChoice: UISegmentedControl = {
        let control = UISegmentedControl(items: [K.Sections.left, K.Sections.middle, K.Sections.right])
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        return control
    }()
    let spinner = UIActivityIndicatorView()
    var tableView = UITableView()
    
    //MARK: - Create other variables
    
    var isLoading = false
    var typeSorted: Int?
    var postManager = PostManager()
    var posts = [PostModel]()
    var currentCursor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        postManager.fetchResults(with: "") { (posts) in
            self.currentCursor = self.postManager.cursorString
            guard posts != nil else { return }
            self.posts += posts!
            self.tableView.reloadData()
        }
    }
    
    @objc func segmentControl(_ segmentControl: UISegmentedControl) {
        
        postManager.fetchResults(with: setupSortedName(object: segmentControl.selectedSegmentIndex)) { (posts) in
            self.posts = []
            guard posts != nil else { return }
            self.posts = posts!
            self.currentCursor = self.postManager.cursorString
            self.tableView.reloadData()
        }
    }
    
    func setupSortedName(object: Int) -> String {
        switch object {
        case 0:
            typeSorted = 0
            return K.FilterName.mostPopular
        case 1:
            typeSorted = 1
            return K.FilterName.mostCommented
        case 2:
            typeSorted = 2
            return K.FilterName.createdAt
        default:
            break
        }
        return ""
    }
}

//MARK: - Setup views

extension PostsViewController {
    
    func setupViews() {
        
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.831372549, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.831372549, alpha: 1)
        
        view.addSubview(titleFilterChoise)
        titleFilterChoise.translatesAutoresizingMaskIntoConstraints = false
        titleFilterChoise.text = K.titleSegmentControl
        titleFilterChoise.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleFilterChoise.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(filterChoice)
        filterChoice.translatesAutoresizingMaskIntoConstraints = false
        filterChoice.topAnchor.constraint(equalTo: titleFilterChoise.bottomAnchor).isActive = true
        filterChoice.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.7882352941, blue: 0.5333333333, alpha: 1)
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
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
        let storyboard = UIStoryboard(name: K.nameStoryboard, bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: K.detailVCname) as! DetailViewController
        if posts.count != 0 {
            let post = posts[indexPath.item]
            detailVC.currentPost = post
            navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            guard !isLoading else { isLoading = false; return }
            isLoading = true
            spinner.startAnimating()
            currentCursor = postManager.cursorString
            guard currentCursor != nil else {
                spinner.stopAnimating()
                getAlert()
                return
            }
            var fullName = ""
            if typeSorted != nil {
                fullName = setupSortedName(object: typeSorted!) + K.FilterName.andAfter + currentCursor!
            } else {
                fullName = K.FilterName.after + currentCursor!
            }
            postManager.fetchResults(with: fullName) { (posts) in
                if posts == nil {
                    self.getAlert()
                } else {
                    self.posts += posts!
                    self.tableView.reloadData()
                }
                self.spinner.stopAnimating()
            }
        }
    }
    
    func getAlert() {
        let alert = UIAlertController(title: "No more posts", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource methods

extension PostsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! PostTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.7882352941, blue: 0.5333333333, alpha: 1)
        
        let post = posts[indexPath.row]
        cell.setupCell(with: post)
        
        return cell
    }
}

