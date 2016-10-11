//
//  SIngleMovieController.swift
//  Flicks
//
//  Created by Alexey Rastaturin on 10/10/16.
//  Copyright © 2016 Alexey Rastaturin. All rights reserved.
//

import UIKit

class SIngleMovieController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    var movie: NSDictionary!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var moviewOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.text = movie["title"] as! String
        moviewOverview.text = movie["overview"] as! String
        
        moviewOverview.sizeToFit()
        
        infoView.frame.size.height = moviewOverview.frame.size.height + 55
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

        if let poster = movie["poster_path"] as! String? {
            let url = NSURL(string: "http://image.tmdb.org/t/p/w500" + poster)
            movieImage.setImageWith(url as! URL)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        

}
