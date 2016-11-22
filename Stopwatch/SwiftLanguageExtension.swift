//
//  SwiftLanguageExtension.swift
//  Cars
//
//  Created by David Vaughn on 9/21/16.
//  Copyright © 2016 University of Missouri - St. Louis. All rights reserved.
//

import Foundation

#if swift(>=3.0)
#else
    typealias URL = NSURL
    typealias TimeInterval = NSTimeInterval
    typealias Data = NSData
    typealias JSONSerialization = NSJSONSerialization
    typealias JSONReadingOptions = NSJSONReadingOptions
    typealias HTTPURLResponse = NSHTTPURLResponse
    typealias URLSession = NSURLSession
    typealias URLRequest = NSURLRequest
    typealias URLSessionConfiguration = NSURLSessionConfiguration
    typealias CharacterSet = NSCharacterSet
    typealias URLSessionDataTask = NSURLSessionDataTask
    typealias OperationQueue = NSOperationQueue
    typealias URLSessionDelegate = NSURLSessionDelegate
    typealias URLSessionDataDelegate = NSURLSessionDataDelegate
    
    extension NSCharacterSet {
    static var alphanumerics: NSCharacterSet {
    return NSCharacterSet.alphanumericCharacterSet()
    }
    }
    
    extension NSData {
    var count: Int {
    return length
    }
    }
    
    extension NSJSONReadingOptions {
    static var mutableLeaves: NSJSONReadingOptions {
    return .MutableLeaves
    }
    }
    
    extension NSJSONSerialization {
    static func jsonObject(with data: NSData, options: NSJSONReadingOptions) throws -> AnyObject {
    return try JSONObjectWithData(data, options: options)
    }
    }
    
    extension NSMutableURLRequest {
    convenience init(url: NSURL) {
    self.init(URL: url)
    }
    
    var httpMethod: String {
    get{
				return HTTPMethod
    } set {
				HTTPMethod = newValue
    }
    }
    }
    
    extension NSURLComponents {
    var url: NSURL? {
    return URL
    }
    }
    
    extension NSURLSession {
    func dataTask(with request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
    return dataTaskWithRequest(request, completionHandler: completionHandler)
    }
    
    func dataTask(with request: NSURLRequest) -> NSURLSessionDataTask {
    return dataTaskWithRequest(request)
    }
    }
    
    extension NSURLSessionConfiguration {
    static var `default`: NSURLSessionConfiguration {
    return NSURLSessionConfiguration.defaultSessionConfiguration()
    }
    }
    
    extension SequenceType where Generator.Element == String {
    func joined(seperator seperator: String) -> String {
    return joinWithSeparator(seperator)
    }
    }
    
    extension String {
    func addingPercentEncoding(withAllowedCharacters characters: NSCharacterSet) -> String? {
    return self.stringByAddingPercentEncodingWithAllowedCharacters(characters)
    }
    
    struct Encoding {
    static var utf8 = NSUTF8StringEncoding
    }
    }
    
    extension MutableCollectionType {
    func sorted(by isOrderedBefore: (Self.Generator.Element, Self.Generator.Element) -> Bool) -> [Self.Generator.Element] {
    return sort(isOrderedBefore)
    }
    }
#endif
