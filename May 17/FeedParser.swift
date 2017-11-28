//
//  FeedParser.swift
//  May 17
//
//  Created by Vigneshkumar G on 28/11/17.
//  Copyright © 2017 Vigneshkumar G. All rights reserved.
//

import Foundation

class FeedParser
{
	func feedItemsFrom(xml:XML) -> [FeedItem]?
	{
		guard let channelNode = xml.rootElement.childNodes.first else {
			return nil
		}
		var feeds = [FeedItem]()
		
		for feedNode in channelNode.childNodes
		{
			if let title = feedNode.childNodesDict["title"]?.value
			{
				let feedItem = FeedItem(title: title)
				feeds.append(feedItem)
			}
		}
		return feeds
	}
}
