//
//  TableViewController.swift
//  NewsTableViewXib
//
//  Created by Sahana Adarsh on 2/23/21.
//

import UIKit
import Alamofire
import SwiftUI
import SwiftyJSON
import SwiftSpinner

class TableViewController: UITableViewController {
        
    var newsTitleArr: [String] = [String]()
    
    var newsArr: [News] = [News]()
        
    @IBOutlet var tblNews: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          getData();
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
                
        cell.lblNewsTitle.text = "\(newsArr[indexPath.row].title) "
                
        return cell
    }
    
    
    func getUrl() -> String{
        
           var url = apiURL
        
           url.append(apiKey)
        
           return url
    }

    
    func getData(){
           
        let url = getUrl()
           
        SwiftSpinner.show("Getting top news titles")
           
        AF.request(url).responseJSON { response in
               
            SwiftSpinner.hide()
                
            if response.error == nil {
                    
                guard let data = response.data else { return }
               
                guard let topNews = JSON(data).dictionary else { return }
                
                let topNewsFetched = topNews["articles"]?.array;

                if topNewsFetched!.count == 0 { return }

                self.newsArr = [News]()

                for news in topNewsFetched! {

                   let author = news["author"].stringValue
                   let title = news["title"].stringValue
                   let descriptions = news["description"].stringValue

                   let news = News()
                   news.author = author
                   news.title = title
                   news.descriptions = descriptions

                   self.newsArr.append(news)
                }

                self.tblNews.reloadData()
            }
               
        }
    }
}
