//
//  ViewController.swift
//  My-Pixabay
//
//  Created by Iskandar Herputra Wahidiyat on 16/06/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    //MARK: - PROPERTIES
    var tempListLength = 0
    var imageArray = [UIImage]()
    var recentSearch = [String]()
    
    var recentSearchRealm = [RecentSearchRealm]()
    
    var searchKeyWord: String!
    
    let searchBar = UISearchBar()
    let activityIndicator = UIActivityIndicatorView()
    let tableView = UITableView()
    let stackView = UIStackView()
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        title = "My Pixabay"
        
        setupSearchBar()
        setupActivityIndicator()
        setupTableView()
        setupCollectionView()
        setupStackView()
        
        //Print path realm file
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        print("recentSearchRealm: \(recentSearchRealm)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readRealmData()
    }

    //MARK: - SETUP UI
    func setupSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.barStyle = .black
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search image here"
        
        searchBar.delegate = self
        
        setSearchBarConstraints()
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.style = .whiteLarge
        
        setActivityIndicatorConstraints()
    }
    
    func setupTableView() {
        tableView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupCollectionView() {
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionViewFlowLayout.itemSize = CGSize(width: view.frame.width/2 - 30, height: view.frame.height/3 - 75)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PixabayCell")
        collectionView.backgroundColor = .black
        
        //collectionView.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        //stackView.distribution = .fillEqually
        
        //stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(collectionView)
        
        setStackViewConstraints()
    }
    
    //MARK: - SET CONSTRAINTS
    func setSearchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK: - ACTIONS
    func readRealmData() {
        let realm = try! Realm()
        let results = realm.objects(RecentSearchRealm.self)
        
        recentSearchRealm.removeAll()
        
        for item in results {
            recentSearchRealm.append(RecentSearchRealm(searchWord: item.searchWord ?? ""))
        }
    }
    
    func fetchPixabayData(searchKeyWord: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            //self.collectionView.isHidden = true
            self.collectionView.alpha = 0
        }
        
        let urlString = "https://pixabay.com/api/?key=14449233-0835cd87d298a8be472fd70bc&q=\(searchKeyWord)&image_type=photo&pretty=true"
        
        guard let url = URL(string: urlString) else {return}
        searchBar.isUserInteractionEnabled = false
        
        
        
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
                self.readRealmData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //self.collectionView.reloadData()
                    //self.collectionView.isHidden = false
                    self.collectionView.alpha = 1
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.searchBar.isUserInteractionEnabled = true
                }
                
            }
            completion()
        }
        task.resume()
    }
    
    func searchDataFromHistory(dataToSearch: String) {
        tableView.isHidden = true
        
        DispatchQueue.main.async {
            //self.collectionView.isHidden = true
            self.tableView.reloadData()
        }
        
        searchBar.resignFirstResponder()
        imageArray.removeAll()
        tempListLength = 0
        
        let recentSearchRealm = RecentSearchRealm()
        recentSearchRealm.searchWord = dataToSearch
        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(recentSearchRealm)
//        }
        
        searchKeyWord = dataToSearch.replacingOccurrences(of: " ", with: "+")
        
        fetchPixabayData(searchKeyWord: searchKeyWord) {
            print("done fetching")
        }
    }
}


extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        readRealmData()
        tableView.isHidden = false
        print(recentSearch)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked")
        
        tableView.isHidden = true
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        searchBar.resignFirstResponder()
        imageArray.removeAll()
        tempListLength = 0
        
        guard let searchKey = searchBar.text else {return}
        //recentSearch.append(searchKey)
        
        let recentSearchRealm = RecentSearchRealm()
        recentSearchRealm.searchWord = searchKey
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(recentSearchRealm)
        }
        
        searchKeyWord = searchKey.replacingOccurrences(of: " ", with: "+")
        print(searchKeyWord!)
        
        fetchPixabayData(searchKeyWord: searchKeyWord) {
            print("done fetching")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return recentSearch.count
        return recentSearchRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        //cell.textLabel?.text = recentSearch[indexPath.row]
        cell.textLabel?.text = recentSearchRealm[indexPath.row].searchWord
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(recentSearchRealm[indexPath.row].searchWord)
        
        guard let dataToSearch = recentSearchRealm[indexPath.row].searchWord else {return}
        
        //let dataToSearch = recentSearchRealm[indexPath.row].searchWord
        
        searchDataFromHistory(dataToSearch: dataToSearch)
        
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
