//
//  ImageColorExtractor.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import Cocoa

internal class ImageColorExtractor {
  enum Corner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    static var all: [Corner] {
      return [.topLeft, .topRight, .bottomLeft, .bottomRight]
    }
  }

  struct ExtractionConfig {
    static var `default` = ExtractionConfig(
      samplePoints: 4,
      gridSize: 5,
      sampleImageSideLength: 141,
      colorPrioritization: []
    )

    struct ColorPrioritization: OptionSet {
      let rawValue: Int

      static let saturated = ColorPrioritization(rawValue: 1 << 0)
      static let bright = ColorPrioritization(rawValue: 1 << 1)
    }

    // The number of areas around the image to sample to determine colors. More sample points will give background colors that are more
    // true to the edges of the image.
    let samplePoints: Int
    // The size of the grid to split the RGB color space into when clustering colors.
    let gridSize: Int
    // The side length of the square images to sample from each corner of the input image to determine a representative color value.
    let sampleImageSideLength: Int
    // Color prioritization options to preference certain attributes when generating representative color values.
    let colorPrioritization: ColorPrioritization
  }

  struct ExtractionDebugInfo {
    // Angle -> (NSImage?, [NSColor])
    let info: [Double: (NSImage?, [NSColor])]
  }

  func extractColors(
    from image: NSImage,
    config: ExtractionConfig = .default
  ) -> [NSColor] {
    var debugInfo: ExtractionDebugInfo?
    return extractColors(from: image, config: config, debugInfo: &debugInfo)
  }

  // Top left color is first, then works its way around 360 degrees.
  func extractColors(
    from image: NSImage,
    config: ExtractionConfig = .default,
    debugInfo outDebugInfo: inout ExtractionDebugInfo?
  ) -> [NSColor] {
    var averageColors = [NSColor]()
    var debugInfo = [Double: (NSImage?, [NSColor])]()

    [0.0, 90.0, 180.0, 270.0].forEach { angle in
      var clippedImage: NSImage?
      let buckets = bucket(
        from: image,
        angle: angle,
        outImage: &clippedImage,
        hottestCorner: .topLeft,
        config: config
      )
      let topColors = buckets.topColors(with: config)
      averageColors.append(topColors.first ?? .black)

      debugInfo[angle] = (clippedImage, Array(topColors[0...min(topColors.count - 1, 4)]))
    }

    outDebugInfo = ExtractionDebugInfo(info: debugInfo)

    return averageColors
  }

  // Angle is in degrees -- 0/360 is the top left corner of the image.
  private func bucket(
    from image: NSImage,
    angle: Double,
    outImage: inout NSImage?,
    hottestCorner: Corner,
    config: ExtractionConfig
  ) -> [Bucket] {
    let angle = angle.truncatingRemainder(dividingBy: 360.0)

    let gridSize = config.gridSize
    var buckets = [[[Bucket]]](repeating: [[Bucket]](), count: gridSize)

    for r in (0..<gridSize) {
      buckets[r] = [[Bucket]](repeating: [Bucket](), count: gridSize)
      for g in (0..<gridSize) {
        buckets[r][g] = [Bucket]()
        for b in (0..<gridSize) {
          buckets[r][g].append(Bucket(redIndex: r, greenIndex: g, blueIndex: b))
        }
      }
    }

    let sourceRect = Corner.topLeft.sampleRect(in: image, sampleSideLength: config.sampleImageSideLength)
    let hottestCornerCoordinates = CGPoint(
      x: CGFloat(hottestCorner.normalizedCoordinates.x) * sourceRect.size.width,
      y: CGFloat(hottestCorner.normalizedCoordinates.y) * sourceRect.size.height
    )

    let bucketWidth = Int(ceil(256.0 / Double(gridSize)))
    image.withImageData(sourceRect: sourceRect, outImage: &outImage) { width, height, pixel in
      for y in (0..<height) {
        for x in (0..<width) {
          let (r, g, b) = pixel(x, y)
          let rIndex = Int(floor(Double(r) / Double(bucketWidth)))
          let gIndex = Int(floor(Double(g) / Double(bucketWidth)))
          let bIndex = Int(floor(Double(b) / Double(bucketWidth)))

          let cornerDistance = sqrt(pow(hottestCornerCoordinates.x - CGFloat(x), 2) + pow(hottestCornerCoordinates.y - CGFloat(y), 2))
          buckets[rIndex][gIndex][bIndex].append(pixel: Pixel(r: r, g: g, b: b), distance: cornerDistance)
        }
      }
    }

    return buckets.flatMap { $0 }.flatMap { $0 }
  }
}

fileprivate extension ImageColorExtractor.Corner {
  var normalizedCoordinates: (x: Int, y: Int) {
    switch self {
    case .topLeft: return (0,0)
    case .topRight: return (1, 0)
    case .bottomLeft: return (0, 1)
    case .bottomRight: return (1, 1)
    }
  }

  func sampleRect(in image: NSImage, sampleSideLength: Int) -> NSRect {
    let sampleImageSize = CGSize(
      width: min(Double(sampleSideLength), floor(image.size.width)),
      height: min(Double(sampleSideLength), floor(image.size.height))
    )

    switch self {
    case .topLeft:
      return NSRect(origin: .zero, size: sampleImageSize)
    case .topRight:
      return NSRect(origin: CGPoint(x: image.size.width - sampleImageSize.width, y: 0), size: sampleImageSize)
    case .bottomLeft:
      return NSRect(origin: CGPoint(x: 0, y: image.size.height - sampleImageSize.height), size: sampleImageSize)
    case .bottomRight:
      return NSRect(origin: CGPoint(x: image.size.width - sampleImageSize.width, y: image.size.height - sampleImageSize.height), size: sampleImageSize)
    }
  }
}

private extension Array where Element == Bucket {
  func topColors(with config: ImageColorExtractor.ExtractionConfig) -> [NSColor] {
    return self
      .map { (color: $0.averageColor, weight: $0.weight) }
      .sorted(by: { a, b in
        let (c1, w1) = a
        let (c2, w2) = b

        // Color prioritization coefficients
        var cp1: Double = 1
        var cp2: Double = 1

        if config.colorPrioritization.contains(.saturated) {
          cp1 *= c1.saturationComponent
          cp2 *= c2.saturationComponent
        }

        if config.colorPrioritization.contains(.bright) {
          cp1 *= c1.brightnessComponent
          cp2 *= c2.brightnessComponent
        }

        return pow(w1, cp1) > pow(w2, cp2)
      })
      .map { $0.color }
  }
}
