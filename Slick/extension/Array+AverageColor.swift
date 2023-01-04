//
//  Array+AverageColor.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import Cocoa

extension Array where Element == Pixel {
  // Use the mean square for more accurate color: https://sighack.com/post/averaging-rgb-colors-the-right-way
  var averageColor: NSColor {
    guard count > 0 else {
      return .black
    }

    let (rSum, gSum, bSum): (UInt64, UInt64, UInt64) = reduce((UInt64(0), UInt64(0), UInt64(0))) { acc, pixel in
      let (r, g, b) = acc
      return (r + UInt64(pixel.r * pixel.r), g + UInt64(pixel.g * pixel.g), b + UInt64(pixel.b * pixel.b))
    }

    let (r, g, b) = (
      sqrt(Double(rSum/UInt64(count))),
      sqrt(Double(gSum/UInt64(count))),
      sqrt(Double(bSum/UInt64(count)))
    )

    return NSColor(srgbRed: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)

  }
}
