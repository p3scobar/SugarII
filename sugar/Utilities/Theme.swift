//
//  Theme.swift
//  devberg
//
//  Created by Hackr on 11/11/17.
//  Copyright © 2017 Hackr. All rights reserved.
//

import UIKit

enum Tint: String {
    case dark = "dark"
    case light = "light"
}

public struct Theme {}

extension Theme {
    
    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
    
    static func semibold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    public static var black: UIColor {
        return UIColor(5, 5, 5)
    }
    
    public static var red: UIColor {
        return UIColor(214, 21, 92)
    }
    
    public static var outgoing: UIColor {
        return UIColor(12, 175, 62)
    }
    
    public static var darkText: UIColor {
        return UIColor(20, 20, 20)
    }
    
    public static var incoming: UIColor {
        return UIColor(68, 68, 68)
    }
    
    public static var white: UIColor {
        return .white
    }
    
    public static var darkBackground: UIColor {
            return UIColor(22, 22, 22)
    }
    
    public static var highlight: UIColor {
        return UIColor(7, 188, 33)
    }
    
    public static var cellBackground: UIColor {
        return UIColor(28, 28, 28)
    }
    
    public static var selectedBackground: UIColor {
        return UIColor(33, 32, 35)
    }
    
    public static var lightBackground: UIColor {
        return UIColor(219, 221, 224)
    }
    
    public static var unfilled: UIColor {
        return UIColor(229, 229, 233)
    }
    
    public static var darkCharcoal: UIColor {
        return UIColor(12, 12, 12)
    }
    
    public static var tintColor: UIColor {
        return UIColor(239, 239, 243)
    }
    
    public static var lightGray: UIColor {
        return UIColor(147, 144, 155)
    }
    
    public static var gray: UIColor {
        return UIColor(125, 125, 125)
    }
    
    public static var darkGray: UIColor {
        return UIColor(32, 32, 32)
    }

    public static var borderColor: UIColor {
        return UIColor(200, 200, 200)
    }
    
    
    
    

}
