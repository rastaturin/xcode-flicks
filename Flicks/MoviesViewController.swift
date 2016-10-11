//
//  ViewController.swift
//  Flicks
//
//  Created by Alexey Rastaturin on 10/9/16.
//  Copyright © 2016 Alexey Rastaturin. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var networkError: UIView!
    @IBOutlet var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!

    
    func refreshAction(sender: AnyObject) {
        
        let apiKey = "3a3c90d66066911173054f36f6b69749"
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                }
            } else {
                self.networkError.isHidden = false
                self.refreshControl.endRefreshing()
            }
        });
        task.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction(sender:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        
        tableView.dataSource = self
        tableView.delegate = self

        refreshAction(sender: self)
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.title.text = movies![indexPath.row]["title"] as! String
        cell.overview.text = movies![indexPath.row]["overview"] as! String
        if let poster = movies![indexPath.row]["poster_path"] as! String? {
            let url = NSURL(string: "http://image.tmdb.org/t/p/w500" + poster)
            cell.MovieImage.setImageWith(url as! URL)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        
        return 0
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailedController = segue.destination as! SIngleMovieController
        detailedController.movie = movie
    }



}

