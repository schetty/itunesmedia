//
//  ViewController.swift
//  iTunesMedia
//
//  Created by Naomi Schettini on 2/20/19.
//  Copyright © 2019 Naomi Schettini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum MediaType {
        case book
        case music
    }
    
    let manager = APIManager()
    let mediaTableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.plain)
    var results = [Result]()
    var loadedResults = [Result]()
    var batchAmount = 20
    var limit = 100
    var selectedMedia: MediaType?
    
    //MARK:- View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        mediaTableView.delegate = self
        mediaTableView.dataSource = self
        
        let musicButton = UIBarButtonItem(title: "Music", style: .plain, target: self, action: #selector(getMusic))
        self.navigationItem.leftBarButtonItem  = musicButton
        
        let bookButton = UIBarButtonItem(title: "Books", style: .plain, target: self, action: #selector(getBooks))
        self.navigationItem.rightBarButtonItem  = bookButton
        self.title = "Top Media"
    }
    
    //MARK:- UI setup
    func setUpTableView() {
        mediaTableView.translatesAutoresizingMaskIntoConstraints = false
        mediaTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.mediaTableView)
    }
    //MARK:- UITableview and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedResults.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = loadedResults[indexPath.row].name
        cell.detailTextLabel?.text = loadedResults[indexPath.row].artistName
        let data = try? Data(contentsOf: URL(string: loadedResults[indexPath.row].artworkUrl100)!)
        if let imageData = data {
            cell.imageView?.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Makeshift pagination for loading 10 more when the user scrolls.
        if indexPath.row == loadedResults.count - 1 {
            // we are at the last loaded result and must paginate more
            if loadedResults.count < limit {
                batchAmount += 10
                guard let currentMedia = selectedMedia else { return }
                switch currentMedia {
                case .book:
                    getBooks()
                case .music:
                    getMusic()
                }
                mediaTableView.reloadData()
            }
        }
    }
    
    //MARK:- Retrieving data methods
    @objc func getMusic() {
        selectedMedia = .music
        manager.getMediaOfType(type: .music, amount: batchAmount, completion: { (success) -> Void in
            self.loadedResults = success.feed.results
            DispatchQueue.main.async {
                self.mediaTableView.reloadData()
            }
        })
    }
    
    @objc func getBooks() {
        selectedMedia = .book
        manager.getMediaOfType(type: .book, amount: batchAmount, completion: { (success) -> Void in
            self.loadedResults = success.feed.results
            DispatchQueue.main.async {
                self.mediaTableView.reloadData()
            }
        })
    }
}

