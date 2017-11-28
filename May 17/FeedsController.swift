//
//  ViewController.swift
//  May 17
//
//  Created by Vigneshkumar G on 28/11/17.
//  Copyright © 2017 Vigneshkumar G. All rights reserved.
//

import UIKit

class FeedsController: UIViewController
{
	var tableView : UITableView!
	var feeds : [FeedItem]?
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		
		
		tableView = UITableView(frame: view.bounds, style: .plain)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 50
		tableView.tableFooterView = UIView()
		view.addSubview(tableView)
		
		navigationItem.title = "May 17 Movement"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshContent))
		
		refreshContent()
		
	}
	
	@objc func refreshContent()
	{
		NetworkService.getFeedsWith { (feeds, error) in
			
			self.feeds = feeds
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
}

extension FeedsController : UITableViewDataSource
{
	func numberOfSections(in tableView: UITableView) -> Int
	{
		if let _ = feeds {
			return 1
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return feeds!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = feeds![indexPath.row].title
		cell.textLabel?.numberOfLines = 0
		return cell
	}
}

extension FeedsController : UITableViewDelegate
{
	
}
