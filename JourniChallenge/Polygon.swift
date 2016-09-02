//
//  Polygon.swift
//  JourniChallenge
//
//  Created by Bruno Paulino on 9/2/16.
//  Copyright © 2016 brunojppb. All rights reserved.
//

struct Polygon {
    
    let coordinates: [[(long: Float, lat: Float)]]
    
}

extension Polygon: GEOJSONObjectSerializable {
    
    init(coordinates: [AnyObject]) {
        
        var polygonCoordinates = [[(long: Float, lat: Float)]]()
        
        for coodinateArr in coordinates {
            let positionsArr = coodinateArr as! [AnyObject]
            var latLongCollection = [(long: Float, lat: Float)]()
            for tupleLikePositions in positionsArr {
                let floatValues = tupleLikePositions as! [Float]
                let point = (long: floatValues[0], lat: floatValues[1])
                latLongCollection.append(point)
            }
            polygonCoordinates.append(latLongCollection)
        }
        
        self.coordinates = polygonCoordinates
    }
    
}