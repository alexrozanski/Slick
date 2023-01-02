//
//  SlickView.swift
//  
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

// Keep this struct internal -- expose a higher-level appearance API if configuratiojn is desired.
internal struct Appearance {
  static var `default` = Appearance(
    blurColors: true,
    opacity: 0.55,
    blurRadius: 29.4,
    horizontalInsets: 22.93,
    verticalInsets: 5.8
  )

  let blurColors: Bool
  let opacity: Double
  let blurRadius: Double
  let horizontalInsets: Double
  let verticalInsets: Double
}

public struct SlickView<Image>: View where Image: View {
  public typealias ImageViewBuilder = (_ nsImage: NSImage) -> Image

  private let imageColorExtractor = ImageColorExtractor()

  private let image: NSImage?
  private let appearance: Appearance
  private let imageView: ImageViewBuilder

  @State private var backgroundColors: [NSColor]?

  // Use this for writes to properties of objects on internalDataHolder.
  @Environment(\.internalDataHolder) private var internalDataHolder
  // Use this for reads of extractionConfig values as this will be reactive.
  @Environment(\.extractionConfig) private var extractionConfig

  private var debugInfo: DebugInfo? = nil

  public init(_ image: NSImage?, @ViewBuilder imageView: @escaping ImageViewBuilder) {
    self.image = image
    self.appearance = .default
    self.imageView = imageView
  }

  init(_ image: NSImage?, appearance: Appearance, @ViewBuilder imageView: @escaping ImageViewBuilder) {
    self.image = image
    self.appearance = appearance
    self.imageView = imageView
  }

  @MainActor public var body: some View {
    if let image = image {
      imageView(image)
        .onAppear {
          recalculateColors(from: image, with: extractionConfig)
        }
        .onChange(of: image) { newImage in
          recalculateColors(from: newImage, with: extractionConfig)
        }
        .onReceive(internalDataHolder.$extractionConfig, perform: { newConfig in
          recalculateColors(from: image, with: newConfig)
        })
        .padding(.horizontal, appearance.horizontalInsets)
        .padding(.vertical, appearance.verticalInsets)
        .background(backgroundGradient)
    }
  }

  @ViewBuilder private var backgroundGradient: some View {
    if let backgroundColors = backgroundColors {
      Rectangle()
        .fill(AngularGradient(gradient: Gradient(
          colors: backgroundColors.map { Color(cgColor: $0.cgColor)}
        ), center: .center, angle: .degrees(225)))
        .opacity(appearance.blurColors ? appearance.opacity : 1)
        .blur(radius: appearance.blurColors ? appearance.blurRadius : 0)
        .blendMode(appearance.blurColors ? .normal : .normal)
    }
  }

  private func recalculateColors(from image: NSImage, with config: ImageColorExtractor.ExtractionConfig) {
    var debugInfo: ImageColorExtractor.ExtractionDebugInfo?
    let colors = imageColorExtractor.extractColors(from: image, config: config, debugInfo: &debugInfo)
    var wrappedColors = colors
    // Wrap the first colour around as backgroundColors is applied to an angular gradient.
    colors.first.map { wrappedColors.append($0) }
    backgroundColors = wrappedColors
    internalDataHolder.debugInfo = debugInfo.map { DebugInfo(colorExtractionDebugInfo: $0) }
  }
}

fileprivate extension DebugInfo {
  convenience init(colorExtractionDebugInfo debugInfo: ImageColorExtractor.ExtractionDebugInfo) {
    var info = [Position: PositionInfo]()
    debugInfo.info.keys.forEach { angle in
      guard
        let (image, colors) = debugInfo.info[angle],
        let image = image
      else { return }

      info[Position(angle: angle)] = PositionInfo(image: image, colors: colors)
    }

    self.init(info: info)
  }
}
