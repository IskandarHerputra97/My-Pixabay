//
//  LandingPageViewController.swift
//  My-Pixabay
//
//  Created by Iskandar Herputra Wahidiyat on 17/06/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {

    //MARK: - PROPERTIES
    let welcomeLabel = UILabel()
    let startButton = UIButton()
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        
        setupWelcomeLabel()
        setupStartButton()
        setupStackView()
    }
    
    //MARK: - SETUP UI
    func setupWelcomeLabel() {
        welcomeLabel.text = "Welcome to My Pixabay"
        welcomeLabel.textColor = .white
        welcomeLabel.font = welcomeLabel.font.withSize(30)
    }
    
    func setupStartButton() {
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .gray
        startButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.addArrangedSubview(welcomeLabel)
        stackView.addArrangedSubview(startButton)
        
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
    @objc func startButtonTapped() {
        let viewController = ViewController()
        navigationController?.setViewControllers([viewController], animated: true)
    }
}
