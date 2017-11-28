//
//  ZML.swift
//  XML
//
//  Created by Vigneshkumar G on 15/03/17.
//  Copyright © 2017 interactivecoconut. All rights reserved.
//

import UIKit

class XML : NSObject
{
    var parser:XMLParser
    let rootElement : XMLNode
    
    init?(xmlString:String)
    {
        
        if let xmlData = xmlString.data(using: .utf8)
        {
            let parser = XMLParser(data: xmlData)
            self.parser = parser
            rootElement = XMLNode()
            parser.delegate = rootElement
            parser.parse()
            super.init()
        }
        else
        {
            return nil
        }
    }
    
    init?(contentsOf url: URL)
    {
        guard let parser = XMLParser(contentsOf: url) else { return nil}
        self.parser = parser
        rootElement = XMLNode()
        parser.delegate = rootElement
        parser.parse()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class XMLNode : NSObject
{
    var name : String?
	
    var value : String?
	
    var attributes : [String:String]?
	
    var childNodesDict : [String:XMLNode]
	
    var childNodes : [XMLNode]
	
    weak var parentNode : XMLNode?
	
    override init() {
        self.name = nil
        self.value = ""
        self.attributes = [String:String]()
        self.childNodes = [XMLNode]()
        self.childNodesDict = [String:XMLNode]()
        super.init()
    }
	
    init(name:String)
    {
        self.name = name
        self.value = ""
        self.attributes = [String:String]()
        self.childNodes = [XMLNode]()
        self.childNodesDict = [String:XMLNode]()
        super.init()
    }
	
    init(name:String,value:String)
    {
        self.name = name
        self.value = value
        self.attributes = [String:String]()
        self.childNodes = [XMLNode]()
        self.childNodesDict = [String:XMLNode]()
        super.init()
    }
	
	struct Keys
	{
		static let name = "name"
		static let value = "value"
		static let attributes = "attributes"
		static let childNodesDict = "childNodesDict"
		static let childNodes = "childNodes"
		static let parentNode = "parentNode"
	}
	
    required init?(coder aDecoder: NSCoder)
	{
		self.name = nil
		self.value = ""
		self.attributes = [String:String]()
		self.childNodes = [XMLNode]()
		self.childNodesDict = [String:XMLNode]()
		
		super.init()
		
        name = aDecoder.decodeObject(forKey: Keys.name) as? String
		value = aDecoder.decodeObject(forKey: Keys.value) as? String
		attributes = aDecoder.decodeObject(forKey: Keys.attributes) as? [String:String]
		childNodesDict = aDecoder.decodeObject(forKey: Keys.childNodesDict) as! [String:XMLNode]
		childNodes = aDecoder.decodeObject(forKey: Keys.childNodes) as! [XMLNode]
		parentNode = aDecoder.decodeObject(forKey: Keys.parentNode) as? XMLNode
    }
	
	func encode(with aCoder: NSCoder)
	{
		aCoder.encode(self.name, forKey: Keys.name)
		aCoder.encode(self.value, forKey: Keys.value)
		aCoder.encode(self.attributes, forKey: Keys.attributes)
		aCoder.encode(self.childNodesDict, forKey: Keys.childNodesDict)
		aCoder.encode(self.childNodes, forKey: Keys.childNodes)
		aCoder.encode(self.parentNode, forKey: Keys.parentNode)
	}
	
	
    override var description: String
    {
        var xmlString = String()
		
        xmlString.append("<\(name!)")
		
        for attributeKey in (self.attributes?.keys)!
        {
            let attributeValue = self.attributes?[attributeKey]
            xmlString.append("  \(attributeKey) = \"\(attributeValue!)\"")
        }
		
        xmlString.append("  >\n")
		
        for childNode in self.childNodes
        {
            xmlString.append(childNode.description)
        }
        xmlString.append("</\(name!)>\n")
		
        return xmlString
    }
}

extension XMLNode : XMLParserDelegate
{
	public func parserDidStartDocument(_ parser: XMLParser)
    {
        
    }
    
	public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
		if self.value == nil {
			self.value = ""
		}
		self.value?.append(string)        
    }
    
	public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        if let _ = self.name , self.name != elementName
        {
            let childNode = XMLNode(name: elementName)
            childNode.parentNode = self
            childNode.attributes = attributeDict
            
            self.childNodes.append(childNode)
            
            if let childNodeName = childNode.name
            {
                self.childNodesDict[childNodeName] = childNode
            }                        
            parser.delegate = childNode
        }
        else
        {
            self.name = elementName
            self.attributes = attributeDict
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if self.name == elementName
        {
            if let parentNode = self.parentNode
            {
                parser.delegate = parentNode
            }
        }
    }
	
	func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
	{
		
	}
	
	func parserDidEndDocument(_ parser: XMLParser)
	{
		
	}
}
