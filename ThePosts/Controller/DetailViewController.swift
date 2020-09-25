//
//  DetailViewController.swift
//  ThePosts
//
//  Created by Антон on 21.09.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    let authorName = UILabel()
    let dateCreated = UILabel()
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let postText = UILabel()
    let viewsCount = UILabel()
    let commentsCount = UILabel()
    var currentPost: PostModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIElements()
        configure()
    }
    
    func setupUIElements() {
        view.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.7882352941, blue: 0.5333333333, alpha: 1)
        
        view.addSubview(authorName)
        authorName.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.9254901961, blue: 0.9490196078, alpha: 1)
        authorName.translatesAutoresizingMaskIntoConstraints = false
        authorName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        authorName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        view.addSubview(dateCreated)
        dateCreated.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.9254901961, blue: 0.9490196078, alpha: 1)
        dateCreated.translatesAutoresizingMaskIntoConstraints = false
        dateCreated.topAnchor.constraint(equalTo: authorName.bottomAnchor, constant: 8).isActive = true
        dateCreated.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        view.addSubview(viewsCount)
        viewsCount.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.9254901961, blue: 0.9490196078, alpha: 1)
        viewsCount.translatesAutoresizingMaskIntoConstraints = false
        viewsCount.topAnchor.constraint(equalTo: dateCreated.bottomAnchor, constant: 8).isActive = true
        viewsCount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        view.addSubview(commentsCount)
        commentsCount.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.9254901961, blue: 0.9490196078, alpha: 1)
        commentsCount.translatesAutoresizingMaskIntoConstraints = false
        commentsCount.topAnchor.constraint(equalTo: viewsCount.bottomAnchor, constant: 8).isActive = true
        commentsCount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: commentsCount.bottomAnchor, constant: 8).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        stackView.addSubview(postText)
        postText.translatesAutoresizingMaskIntoConstraints = false
        postText.numberOfLines = 0
        postText.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        postText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        postText.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        postText.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func configure() {
        authorName.text = "Author name is \(currentPost?.authorName ?? "noname")"
        dateCreated.text = "Created at \(currentPost?.dateCreated ?? "unnown date")"
        postText.text = currentPost?.postText
        viewsCount.text = "views: \(currentPost?.viewsCount.description ?? "0")"
        commentsCount.text = "comments: \(currentPost?.commentsCount.description ?? "0")"
    }

}

