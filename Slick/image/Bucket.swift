//
//  Bucket.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import Cocoa

internal struct Bucket {
  let redIndex: Int
  let greenIndex: Int
  let blueIndex: Int

  private(set) var weight: Double = 0
  private(set) var pixels: [Pixel] = []

  mutating func append(pixel: Pixel, distance: Double) {
    pixels.append(pixel)
    // Exponential decay of f = ab^x, a and b determined experimentally.
    weight += 100.0 * pow(0.9, distance)
  }

  var averageColor: NSColor {
    return pixels.averageColor
  }
}
