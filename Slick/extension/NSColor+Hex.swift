//
//  NSColor+Hex.swift
//  Slick
//
//  Created by Alex Rozanski on 03/01/2023.
//

import Cocoa

// From https://stackoverflow.com/a/32345031/75245
extension NSColor {
  var hexString: String {
    let red = Int(round(self.redComponent * 0xFF))
    let green = Int(round(self.greenComponent * 0xFF))
    let blue = Int(round(self.blueComponent * 0xFF))
    let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
    return hexString as String
  }
}
