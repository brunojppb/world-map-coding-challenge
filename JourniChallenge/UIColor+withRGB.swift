//
//  UIColor+withRGB.swift
//  JourniChallenge
//
//  Created by Bruno Paulino on 9/2/16.
//  Copyright © 2016 brunojppb. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func withRGB(red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
    
}

