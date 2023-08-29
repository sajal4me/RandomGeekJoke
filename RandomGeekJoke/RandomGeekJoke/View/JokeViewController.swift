//
//  JokeViewController.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import UIKit

final class JokeViewController: UIViewController, UITableViewDelegate {
    
    private let progressBar: CircularProgressBarView
    private var timer: Timer?
    private var totalTime: TimeInterval = 10 // Total time for the timer in seconds
    private var currentTime: TimeInterval = 0
    private let presenter: JokePresenter
    
    init(presenter: JokePresenter, progressBar: CircularProgressBarView) {
        self.presenter = presenter
        self.progressBar = progressBar
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(JokeTableViewCell.self, forCellReuseIdentifier: "JokeTableViewCell")
        
        return tableView
    }()
    
    enum Section {
        case main
    }
    
    private var dataSource: UITableViewDiffableDataSource <Section, JokeModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        presenter.delegate = self
        tableView.delegate = self
        setupDataSource()
        
        presenter.fetchJokes()
        
        self.progressBar.completionHandler = { [weak self] in
            self?.presenter.fetchJokes()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.frame
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "JokeTableViewCell", for: indexPath) as! JokeTableViewCell
            
            cell.titleLabel.text = model.joke
            
            return cell
        })
    }
    
    private func updateDataSource(jokes: [JokeModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, JokeModel>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(jokes)
        
        dataSource.applySnapshotUsingReloadData(snapshot)
        self.restartProgressBar()
    }
    
    private func startProgressBar() {
        timer?.invalidate() // Invalidate the existing timer if any
        timer = Timer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
        // Use a run loop to control the timer execution
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    @objc func updateProgress() {
        currentTime += 0.1
        let progress = CGFloat(currentTime / totalTime)
        progressBar.progress = progress
        
        if currentTime >= totalTime {
            timer?.invalidate()
            progressBar.completionHandler?()
        }
    }
    
    private func restartProgressBar() {
        currentTime = 0
        progressBar.progress = 0
        startProgressBar()
    }
}

extension JokeViewController: JokeDelegate {
    
    func present(jokes: [JokeModel]) {
        updateDataSource(jokes: jokes)
    }
    
    func present(error: Error) {
        
    }
}


