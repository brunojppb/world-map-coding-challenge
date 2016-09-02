//
//  ViewController.swift
//  JourniChallenge
//
//  Created by Bruno Paulino on 9/2/16.
//  Copyright © 2016 brunojppb. All rights reserved.
//

import UIKit

enum WorldMap {
    static let scale: Float = 10000.0
}

class ChallengeViewController: UIViewController {
    
    var polygons = [Polygon]()
    var scrollView: UIScrollView!
    var mapView: UIView!
    // An offset to the map that will be displayed.
    // given that the points have negative values and we will draw
    // the map starting from (x: 0, y: 0), we need to add an offset for each axis.
    var xOffset: Float!
    var yOffset: Float!
    
    // Define the width and height of the map 
    // based on the bounding box from GEOJSON file
    var mapViewWidth: Float!
    var mapViewHeight: Float!

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.startupChallenge()
    }
    
    func startupChallenge() {
        
        self.setupScrollView()
        
        guard let json = GEOJSONParser.sharedInstance.parseGEOJSONFile("countries_small") else {
            print("Error parsing GEOJSON File")
            self.showAlertMessage("Ops!", message: "Error parsing GEOJSON file")
            return
        }
        
        // Get the bounding box of the GEOJSON
        let boundaries = json["bbox"] as! [Float]
        // We need to scale down the values to see a small map on the screen.
        self.xOffset = (boundaries[0] * -1) / WorldMap.scale
        self.yOffset = (boundaries[1] * -1) / WorldMap.scale
        
        
        self.mapViewWidth = ((boundaries[0] * -1) + boundaries[2]) / WorldMap.scale
        self.mapViewHeight = ((boundaries[1] * -1) + boundaries[3]) / WorldMap.scale
        
        // Instanciate Polygons
        let features = json["features"] as! [AnyObject]
        for feature in features {
            let geometry = feature["geometry"] as! [String: AnyObject]
            let type = geometry["type"] as! String
            let coordinates = geometry["coordinates"] as! [AnyObject]
            
            switch type {
            case "Polygon":
                self.polygons.append(Polygon(coordinates: coordinates))
                break
            // Given that a MultiPolygon is just a collection of Polygons
            case "MultiPolygon":
                for coordinatesCollection in coordinates {
                    let nestedCoodinates = coordinatesCollection as! [AnyObject]
                    self.polygons.append(Polygon(coordinates: nestedCoodinates))
                }
                break
            default:
                print("There is no implementation for other geometry type")
            }
        }
        
        // Creates the map view based on the GEOJSON bbox values
        self.setupMapView()
        
        // Draws each polygon on the map view
        for polygon in self.polygons {
            self.drawPolygonOnMapView(polygon)
        }
        
    }
    
    func setupScrollView() {
        // Setup the ScrollView
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.scrollView.backgroundColor = UIColor.withRGB(163, green: 204, blue: 255)
        self.scrollView.delegate = self
        self.scrollView.bounces = true
        self.scrollView.alwaysBounceHorizontal = true
        self.scrollView.minimumZoomScale = 0.19
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.zoomScale = 2.0
        self.view.addSubview(self.scrollView)
    }
    
    func setupMapView() {
        let frame = CGRectMake(0, 0, CGFloat(self.mapViewWidth), CGFloat(self.mapViewHeight))
        self.mapView = UIView(frame: frame)
        self.scrollView.contentSize = self.mapView.bounds.size
        self.scrollView.addSubview(mapView)
        // Add an offset to see part of the map on startup
        self.scrollView.contentOffset = CGPointMake(self.mapView.bounds.size.width/2, self.mapView.bounds.size.height/2)
    }
    
    func drawPolygonOnMapView(polygon: Polygon) {
        let shape = CAShapeLayer()
        shape.opacity = 0.9
        shape.lineWidth = 2
        shape.strokeColor = UIColor.darkGrayColor().CGColor
        shape.fillColor = UIColor.withRGB(216, green: 230, blue: 211).CGColor
        
        let composablePath = UIBezierPath()
        
        for coordinatesCollection in polygon.coordinates {
            // Creates a path that will compose the country representation
            let path = UIBezierPath()
            for (index, coordinates) in coordinatesCollection.enumerate() {
                let x = CGFloat((coordinates.long / WorldMap.scale) + self.xOffset)
                // The iOS coordinate system has its origin at the upper left of the drawing area, 
                // and positive values extend down and to the right from it.
                // Given that the GEOJSON Y axis is meant to be the other way around
                // we need to multiply by -1, otherwise the map will be upside down.
                let y = CGFloat(((coordinates.lat * -1) / WorldMap.scale) + self.yOffset)
                if index == 0 {
                    path.moveToPoint(CGPointMake(x, y))
                } else {
                    path.addLineToPoint(CGPointMake(x, y))
                }
            }
            path.closePath()
            composablePath.appendPath(path)
        }
        
        // Drawing the layer as a vector is expensive.
        // To improve performance, enable rasterization.
        // Rendering the layer as a bitmap.
        shape.shouldRasterize = true
        shape.rasterizationScale = 0.70
        shape.allowsEdgeAntialiasing = false
        
        composablePath.closePath()
        shape.path = composablePath.CGPath
        
        self.mapView.layer.addSublayer(shape)
    }
    
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}


// MARK: - UIScrollViewDelegate
/*
 Following the [Ray Wenderlich style guide](https://github.com/raywenderlich/swift-style-guide)
 Create an extension for protocol conformance
 */
extension ChallengeViewController: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.mapView
    }
    
}

