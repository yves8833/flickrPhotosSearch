//
//  ViewController.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/11.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        
        return stackView
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.tintColor = .lightGray
        textField.placeholder = "欲搜尋內容"
        
        return textField
    }()
    
    lazy var photosNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.tintColor = .lightGray
        textField.placeholder = "每頁呈現數量"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    lazy var searchButton: CustomButton = {
        let button = CustomButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("搜尋", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        layoutInitialView()
    }
    
}

// MARK: Private Method
extension ViewController {
    private func layoutInitialView() {
        self.navigationItem.title = "搜尋輸入頁"
        self.view.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(searchTextField)
        contentStackView.addArrangedSubview(photosNumberTextField)
        contentStackView.addArrangedSubview(searchButton)
        
        contentStackView.arrangedSubviews.forEach { (view) in
            view.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 30),
            photosNumberTextField.heightAnchor.constraint(equalTo: searchTextField.heightAnchor),
            searchButton.heightAnchor.constraint(equalTo: searchTextField.heightAnchor)
        ])
    }
}

// MARK: IBAction
extension ViewController {
    @objc func search() {
        guard let searchName = searchTextField.text, !searchName.isEmpty,  let photosNumber = photosNumberTextField.text, !photosNumber.isEmpty else {
            return
        }
        
        let tabBarViewController = TabBarViewController.init(With: searchName)
        
        let photosSearchViewController = PhotosSearchViewController.init(With: searchName, photosNumber: photosNumber)
        let item1 : UITabBarItem = .init(tabBarSystemItem: .featured, tag: 0)
        photosSearchViewController.tabBarItem = item1
        
        let favoriteViewController = FavoriteViewController()
        let item2 : UITabBarItem = .init(tabBarSystemItem: .favorites, tag: 1)
        favoriteViewController.tabBarItem = item2
        
        tabBarViewController.viewControllers = [photosSearchViewController, favoriteViewController]
        
        self.navigationController?.pushViewController(tabBarViewController, animated: true)
    }
}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchButton.isEnabled = !(searchTextField.text?.isEmpty ?? true) && !(photosNumberTextField.text?.isEmpty ?? true)
    }
}


