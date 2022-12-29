//
//  DebugColorInfo.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

internal class DebugInfo: ObservableObject {
  let topLeftSampledImage: NSImage?
  let topLeftColors: [NSColor]?
  let topRightSampledImage: NSImage?
  let topRightColors: [NSColor]?
  let bottomLeftSampledImage: NSImage?
  let bottomLeftColors: [NSColor]?
  let bottomRightSampledImage: NSImage?
  let bottomRightColors: [NSColor]?

  init(
    topLeftSampledImage: NSImage?,
    topLeftColors: [NSColor]?,
    topRightSampledImage: NSImage?,
    topRightColors: [NSColor]?,
    bottomLeftSampledImage: NSImage?,
    bottomLeftColors: [NSColor]?,
    bottomRightSampledImage: NSImage?,
    bottomRightColors: [NSColor]?
  ) {
    self.topLeftSampledImage = topLeftSampledImage
    self.topLeftColors = topLeftColors
    self.topRightSampledImage = topRightSampledImage
    self.topRightColors = topRightColors
    self.bottomLeftSampledImage = bottomLeftSampledImage
    self.bottomLeftColors = bottomLeftColors
    self.bottomRightSampledImage = bottomRightSampledImage
    self.bottomRightColors = bottomRightColors
  }
}

internal struct DebugInfoKey: EnvironmentKey {
  static var defaultValue: DebugInfo? = nil
}

internal extension EnvironmentValues {
  var debugInfo: DebugInfo? {
    get { self[DebugInfoKey.self] }
    set { self[DebugInfoKey.self] = newValue }
  }
}
