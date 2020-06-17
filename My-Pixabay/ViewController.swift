//
//  ViewController.swift
//  My-Pixabay
//
//  Created by Iskandar Herputra Wahidiyat on 16/06/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - PROPERTIES
    var tempListLength = 0
    
    var imageArray = [UIImage]()
    
    var searchKeyWord: String!
    
    let searchBar = UISearchBar()
    let stackView = UIStackView()
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        title = "My Pixabay"
        
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PixabayCell")
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
    
    //MARK: - ACTIONS
    func fetchPixabayData(searchKeyWord: String, completion: @escaping () -> Void) {
        let urlString = "https://pixabay.com/api/?key=14449233-0835cd87d298a8be472fd70bc&q=\(searchKeyWord)&image_type=photo&pretty=true"
        
        guard let url = URL(string: urlString) else {return}
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            
            let pixabayList = try? JSONDecoder().decode(Pixabay.self, from: data)
            
            if let pixabayList = pixabayList {
                self.tempListLength += pixabayList.hits.count
                for item in pixabayList.hits {
                    print(item.previewURL)
                    
                    let newData = try? Data(contentsOf: item.previewURL)
                    
                    if let newData = newData {
                        
                        self.imageArray.append(UIImage(data: newData)!)
                        print("newData: \(newData)")
                    }
                    
                    
                }
                print("imageArray: \(self.imageArray)")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            completion()
        }
        task.resume()
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked")
        
        searchBar.resignFirstResponder()
        imageArray.removeAll()
        tempListLength = 0
        
        guard let searchKey = searchBar.text else {return}
        
        searchKeyWord = searchKey.replacingOccurrences(of: " ", with: "+")
        print(searchKeyWord!)
        
        fetchPixabayData(searchKeyWord: searchKeyWord) {
            print("done fetching")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempListLength
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PixabayCell", for: indexPath)
        
        cell.backgroundColor = .gray
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width/2 - 30, height: view.frame.height/3 - 75))
        
        guard imageArray.count == tempListLength && tempListLength > 0 else {return cell}
        
        imageView.image = imageArray[indexPath.row]
        
        cell.contentView.addSubview(imageView)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        return cell
    }
    
    
}
