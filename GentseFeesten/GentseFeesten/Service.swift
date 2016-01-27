//
//  Service.swift
//  GentseFeesten
//
//  Created by Yannick Van Hecke on 12/01/16.
//  Copyright © 2016 Yannick Van Hecke. All rights reserved.
//

import Foundation

// Parkingslots
class Service {
    
    enum Error: ErrorType
    {
        case InvalidJsonData(message: String?)
        case MissingJsonProperty(name: String)
        case MissingResponseData
        case NetworkError(message: String?)
        case UnexpectedStatusCode(code: Int)
    }
    
    // Singleton
    static let service = Service()
    
    private let url: NSURL
    private let session: NSURLSession
    
    private init() {
        let path = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: path)!
        url = NSURL(string: properties["baseUrl"] as! String)!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }
    
    func createFetchTask(completionHandler: Result<[Event]> -> Void) -> NSURLSessionTask {
        return session.dataTaskWithURL(url) {
            data, response, error in
            let completionHandler: Result<[Event]> -> Void = {
                result in
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(result)
                }
            }
            
            guard let response = response as? NSHTTPURLResponse else {
                completionHandler(.Failure(.NetworkError(message: error?.description)))
                return
            }
            guard response.statusCode == 200 else {
                completionHandler(.Failure(.UnexpectedStatusCode(code: response.statusCode)))
                return
            }
            guard let data = data else {
                completionHandler(.Failure(.MissingResponseData))
                return
            }
            do {
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [NSDictionary] else {
                    completionHandler(.Failure(.InvalidJsonData(message: "Data does not contain a root object.")))
                    return
                }
                
                // json komt correct binnen, maar wordt niet goed gemapt.
                do{
                    let events = try json.map{ try Event(json: $0) }
                    completionHandler(.Success(events))
                }
                catch let error as Error
                {
                    completionHandler(.Failure(error))
                }
                
            } catch let error as Error {
                completionHandler(.Failure(error))
            } catch let error as NSError {
                completionHandler(.Failure(.InvalidJsonData(message: error.description)))
            }
        }
    }
}