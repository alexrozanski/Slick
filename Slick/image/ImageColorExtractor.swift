//
//  ImageColorExtractor.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import Cocoa
import Algorithms

internal class ImageColorExtractor {
  struct ExtractionConfig {
    static var `default` = ExtractionConfig(
      samplePoints: 8,
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
    var samplePoints: Int
    // The size of the grid to split the RGB color space into when clustering colors.
    var gridSize: Int
    // The side length of the square images to sample from each point of the input image to determine a representative color value.
    let sampleImageSideLength: Int
    // Color prioritization options to preference certain attributes when generating representative color values.
    let colorPrioritization: ColorPrioritization

    // Mutations
    func withSamplePoints(_ newSamplePoints: Int) -> ExtractionConfig {
      return ExtractionConfig(samplePoints: newSamplePoints, gridSize: gridSize, sampleImageSideLength: sampleImageSideLength, colorPrioritization: colorPrioritization)
    }

    func withGridSize(_ newGridSize: Int) -> ExtractionConfig {
      return ExtractionConfig(samplePoints: samplePoints, gridSize: newGridSize, sampleImageSideLength: sampleImageSideLength, colorPrioritization: colorPrioritization)
    }
  }

  struct BackgroundColor: Hashable {
    // Expressed in 0 <= degrees <= 360
    let angle: Double
    let color: NSColor

    func hash(into hasher: inout Hasher) {
      hasher.combine(color.redComponent)
      hasher.combine(color.greenComponent)
      hasher.combine(color.blueComponent)
      hasher.combine(angle)
    }
  }

  struct ExtractionDebugInfo {
    // Angle -> (NSImage?, [NSColor])
    let info: [Double: (NSImage?, [NSColor])]
  }

  func extractColors(
    from image: NSImage,
    config: ExtractionConfig = .default,
    completion: @escaping ([BackgroundColor]) -> Void,
    completionQueue: DispatchQueue = .main
  ) {
    extractColors(from: image, config: config, completion: { colors, _ in
      completion(colors)
    }, completionQueue: completionQueue)
  }

  // Top left color is first, then works its way around 360 degrees.
  func extractColors(
    from image: NSImage,
    config: ExtractionConfig = .default,
    completion: @escaping ([BackgroundColor], ExtractionDebugInfo) -> Void,
    completionQueue: DispatchQueue = .main
  ) {
    DispatchQueue.global(qos: .userInitiated).async {
      var backgroundColors = [BackgroundColor]()
      var debugInfo = [Double: (NSImage?, [NSColor])]()

      let interval = 360.0 / Double(config.samplePoints)
      let points = (0..<config.samplePoints).map { i in Double(i) * interval }
      points.forEach { angle in
        var clippedImage: NSImage?
        let buckets = self.bucket(
          from: image,
          angle: angle,
          outImage: &clippedImage,
          config: config
        )
        let topColors = buckets.topColors(with: config)
        backgroundColors.append(BackgroundColor(angle: angle, color: topColors.first ?? .black))

        debugInfo[angle] = (clippedImage, Array(topColors[0...min(topColors.count - 1, 4)].uniqued()))
      }

      completionQueue.async {
        completion(backgroundColors, ExtractionDebugInfo(info: debugInfo))
      }
    }
  }

  // Angle is in degrees -- 0/360 is the top left corner of the image.
  private func bucket(
    from image: NSImage,
    angle: Double,
    outImage: inout NSImage?,
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

    let sampleCenterPoint = edgeCoordinates(for: angle, inRectWithSize: image.size)

    // Focus point is the point in `sampleRect` at which the colour influence should be the strongest.
    var focusPoint: CGPoint = .zero
    let sampleRect = sampleRect(
      for: sampleCenterPoint,
      in: image,
      sampleSideLength: config.sampleImageSideLength,
      outCenterPoint: &focusPoint
    )

    var sampleImage: NSImage?
    let bucketWidth = Int(ceil(256.0 / Double(gridSize)))
    image.withImageData(sourceRect: sampleRect, outImage: &sampleImage) { width, height, pixel in
      for y in (0..<height) {
        for x in (0..<width) {
          let (r, g, b) = pixel(x, y)
          let rIndex = Int(floor(Double(r) / Double(bucketWidth)))
          let gIndex = Int(floor(Double(g) / Double(bucketWidth)))
          let bIndex = Int(floor(Double(b) / Double(bucketWidth)))

          let focusPointDistance = sqrt(pow(focusPoint.x - CGFloat(x), 2) + pow(focusPoint.y - CGFloat(y), 2))
          buckets[rIndex][gIndex][bIndex].append(pixel: Pixel(r: r, g: g, b: b), distance: focusPointDistance)
        }
      }
    }

    outImage = sampleImage.flatMap { annotatedSampleImage($0, markerPoint: focusPoint) }

    return buckets.flatMap { $0 }.flatMap { $0 }
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

// Get a sample rect from the source image from the centerPoint (of the sample rect) which should be on the edge of the image bounds.
// `centerPoint` is returned in the sampleRect's coordinate system as `outCenterPoint` is
private func sampleRect(for centerPoint: CGPoint, in image: NSImage, sampleSideLength: Int, outCenterPoint: inout CGPoint) -> NSRect {
  let imageRect = NSRect(origin: .zero, size: image.size)
  let sampleRect = NSIntersectionRect(
    imageRect,
    NSRect(
      x: centerPoint.x - Double(sampleSideLength),
      y: centerPoint.y - Double(sampleSideLength),
      width: Double(sampleSideLength) * 2,
      height: Double(sampleSideLength) * 2
    )
  )
  outCenterPoint = CGPoint(x: centerPoint.x - sampleRect.minX, y: centerPoint.y - sampleRect.minY)
  return sampleRect
}

let annotationMarkerRadius = Double(5)
private func annotatedSampleImage(_ sampleImage: NSImage, markerPoint: CGPoint) -> NSImage? {
  let sampleImageSize = sampleImage.size
  return NSImage(
    size: CGSize(width: sampleImageSize.width + 2 * annotationMarkerRadius, height: sampleImageSize.height + 2 * annotationMarkerRadius),
    flipped: false
  ) { rect in
    guard let context = NSGraphicsContext.current?.cgContext else { return false }
    context.saveGState()
    defer {
      context.restoreGState()
    }

    sampleImage.draw(at: CGPoint(x: annotationMarkerRadius, y: annotationMarkerRadius), from: .zero, operation: .sourceOver, fraction: 1.0)

    // Flip y coordinates.
    let circleRect = NSRect(
      x: markerPoint.x,
      y: sampleImageSize.height - markerPoint.y,
      width: annotationMarkerRadius * 2,
      height: annotationMarkerRadius * 2
    )
    NSColor.white.setFill()
    NSColor.black.withAlphaComponent(0.2).setStroke()
    // Inset by (0.5, 0.5) so that stroke falls on the edge of the bounding rect
    let path = NSBezierPath(ovalIn: circleRect.insetBy(dx: 0.5, dy: 0.5))
    path.fill()
    path.stroke()

    return true
  }
}
