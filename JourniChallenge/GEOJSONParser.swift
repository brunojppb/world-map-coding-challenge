//
//  GEOJSONParser.swift
//  JourniChallenge
//
//  Created by Bruno Paulino on 9/2/16.
//  Copyright © 2016 brunojppb. All rights reserved.
//

import UIKit

class GEOJSONParser {
    
    static let sharedInstance = GEOJSONParser()
    // With a private init, the user can't create an instance.
    // Force the use of the singleton
    private init() {}
    
    
    /**
     Parses a `GEOJSON` file.
     
     - Parameter filename:   The name of the file located in the project.
     
     - Returns: the serialized `JSON` as a dictionary.
     */
    func parseGEOJSONFile(filename: String) -> [String: AnyObject]? {
        let fileURL = NSBundle.mainBundle().URLForResource(filename, withExtension: "geojson")
        guard let url = fileURL else {
            print("File not found")
            return nil
        }
        let data = NSData(contentsOfURL: url)
        
        do {
            let json: [String: AnyObject] = try NSJSONSerialization
                                                .JSONObjectWithData(data!, options: .AllowFragments) as! [String: AnyObject]
            return json
            
        } catch _ {
            print("Error parsing GEOJSON File")
        }
        
        return nil
    }
    
}
