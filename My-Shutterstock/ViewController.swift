//
//  ViewController.swift
//  My-Shutterstock
//
//  Created by Iskandar Herputra Wahidiyat on 16/06/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - PROPERTIES
    let searchBar = UISearchBar()
    let stackView = UIStackView()
    //var collectionView = UICollectionView()
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        title = "My Shutterstock"
        
        setupSearchBar()
        setupCollectionView()
        setupStackView()
    }

    //MARK: - SETUP UI
    func setupSearchBar() {
        searchBar.barStyle = .black
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search image here"
        
        searchBar.delegate = self
    }
    
    func setupCollectionView() {
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionViewFlowLayout.itemSize = CGSize(width: view.frame.width/2 - 30, height: view.frame.height/3 - 75)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ShutterCell")
        collectionView.backgroundColor = .black
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(collectionView)
        
        setStackViewConstraints()
    }
    
    //MARK: - SET CONSTRAINTS
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        print("rotate")
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShutterCell", for: indexPath)
        
        cell.backgroundColor = .gray
        
//        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
//        containerView.backgroundColor = .green
//
//        cell.contentView.addSubview(containerView)
        
        return cell
    }
    
    
}
