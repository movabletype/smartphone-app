//
//  Color.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/05/19.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import Foundation

func colorize(hex: Int, alpha: Double = 1.0) -> UIColor {
    let red     = Double((hex & 0xFF0000) >> 16) / 255.0
    let green   = Double((hex & 0xFF00  ) >> 8 ) / 255.0
    let blue    = Double((hex & 0xFF    )      ) / 255.0
    var color: UIColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    return color
}

class Color {
    class var clear: UIColor {
        return colorize(0xFFFFFF, alpha: 0.0)
    }
    
    class var white: UIColor {
        return colorize(0xFFFFFF)
    }
    
    class var black: UIColor {
        return colorize(0x000000)
    }
    
    class var navBar: UIColor {
        return colorize(0x4a4a4a)
    }

    class var navBarTitle: UIColor {
        return colorize(0xffffff)
    }
    
    class var navBarTint: UIColor {
        return colorize(0xffffff)
    }
    
    class var bg: UIColor {
        return colorize(0xffffff)
    }
    
    class var tableBg: UIColor {
        return colorize(0xf5f5f5)
    }
    
    class var linkText: UIColor {
        return colorize(0x00b2dd)
    }
    
    class var loginBgStart: UIColor {
        return colorize(0x2a3048)
    }
    
    class var loginBgEnd: UIColor {
        return colorize(0x0e111d)
    }
    
    class var signinButtonBg: UIColor {
        return colorize(0x00b2dd)
    }
    
    class var basicAuthButtonBg: UIColor {
        return colorize(0x00b2dd, alpha: 0.2)
    }

    class var buttonText: UIColor {
        return colorize(0xffffff)
    }

    class var buttonDisableText: UIColor {
        return colorize(0x1b2031)
    }
    
    class var separatorLine: UIColor {
        return colorize(0xe0e0e0)
    }
    
    class var cellText: UIColor {
        return colorize(0x5b5c59)
    }
    
    class var placeholderText: UIColor {
        return colorize(0x838383)
    }
    
}
