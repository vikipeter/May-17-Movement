//
//  NetworkService.swift
//  May 17
//
//  Created by Vigneshkumar G on 28/11/17.
//  Copyright © 2017 Vigneshkumar G. All rights reserved.
//

import Foundation

typealias FeedsCompletion = ([FeedItem]?,Error?) -> Void

enum FeedError : Error
{
	case parserFails
}

class NetworkService
{
	static func getFeedsWith(completion:@escaping FeedsCompletion) {
		
		let urlSession = URLSession.shared
		
		let url = URL.init(string: "https://may17iyakkam.com/feed/")!
		
		let dataTask = urlSession.dataTask(with: url) { (data, urlResponse, error) in
			
			if let error = error{
				completion(nil, error)
			}
			if let data = data{
				if let dataString = String.init(data: data, encoding: .utf8){
					
					if let xml = XML.init(xmlString: dataString)
					{
						let feedParser = FeedParser()
						if let feeds = feedParser.feedItemsFrom(xml: xml)
						{
							completion(feeds,nil)
						}
						else
						{
							completion(nil,FeedError.parserFails)
						}
					}
				}
			}
		}
		
		dataTask.resume()
	}
}
