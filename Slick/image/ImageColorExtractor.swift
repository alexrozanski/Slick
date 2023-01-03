//
//  ImageColorExtractor.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import Cocoa

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

  struct ExtractionDebugInfo {
    // Angle -> (NSImage?, [NSColor])
    let info: [Double: (NSImage?, [NSColor])]
  }

  func extractColors(
    from image: NSImage,
    config: ExtractionConfig = .default,
    completion: @escaping ([NSColor]) -> Void,
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
    completion: @escaping ([NSColor], ExtractionDebugInfo) -> Void,
    completionQueue: DispatchQueue = .main
  ) {
    DispatchQueue.global(qos: .userInitiated).async {
      var averageColors = [NSColor]()
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
        averageColors.append(topColors.first ?? .black)

        debugInfo[angle] = (clippedImage, Array(topColors[0...min(topColors.count - 1, 4)]))
      }

      completionQueue.async {
        completion(averageColors, ExtractionDebugInfo(info: debugInfo))
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

    let edgeCoordinates = edgeCoordinates(for: angle, in: image)

    // Focus point is the point in `sampleRect` at which the colour influence should be the strongest.
    var focusPoint: CGPoint = .zero
    let sampleRect = sampleRect(
      for: edgeCoordinates,
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

/*
    Calculate the coordinates for a point on the edge of the image to sample given an angle.

    The vector maths is based on this answer: https://math.stackexchange.com/a/1760644, where we
    center the image at the origin:

                        θ' = 90deg
                             ↑
                             |   |v|
                 ↑ +---------|---/-----+
                 | |     +---|--/      |
            h/2  | |    / θ' | /       |
                 ↓ |   /     |/        |
    θ' = 0deg --------+------+---------------> θ' = 180deg
                 ↑ |         |         |
            h/2  | |         |         |
                 | |         |         |
                 ↓ +---------|---------+

                       θ' = 270deg

                   <--------> <-------->
                      w/2         w/2

     - Our input `angle`, θ is defined where 0deg is the top left corner of the image and sweeps
       clockwise round the image,
       but we define our θ' where 0deg is the direction of the unit vector { -1, 0 }.
     - Therefore θ' = θ + 45deg.
     - For some unit vector |u| = {cos(θ'), sin(θ')}, we want to find a vector |v| (as per the
       Stack Exchange answer) where |v| = λ|u| and solve for some value of λ.

    We define |v| as (multiplying |u| by λ):

          ⌈    ⌈ h.cos(θ')     w.cos(θ')  ⌉ ⌉
          | min|----------    ----------- | |
     →    |    ⌊ 2|cos(θ')| ,  2|sin(θ')| ⌋ |
     v  = |                                 |
          |    ⌈ h.sin(θ')     w.sin(θ')  ⌉ |
          | min|----------    ----------- | |
          ⌊    ⌊ 2|cos(θ')| ,  2|sin(θ')| ⌋ ⌋

    And label the first and second terms to min() for the x value of |v| as `t1` and `t2`, and
    the first and second terms to min() for the y value of |v| as `t3` and `t4`.

    In `t1`, cos(θ') on the top and bottom cancel out, and in `t4` the sin(θ') on the top and
    bottom cancel out, so we simplify `t1` and `t4` to (h/2) and (w/2) respectively. This also
    simplifies our calculations because we don't have to account for division by zero.

    However we still need to account for the case where cos(θ') or sin(θ') is negative, as this
    will change the sign of our `t1` and `t4` values (because we divide cos(θ') by |cos(θ')| and
    sin(θ') by |cos(θ')| respectively). We use `t1Sign` and `t4Sign` for this.

    The min()s in the original equation are to ignore division by zero values (in these cases we
    set `t2` and `t4` to infinity) but these crucially should only be applied to the magnitude of
    (t1, t2) and (t3, t4) to ignore the infinity values. If we applied them to the signed values
    of t1 and t4 some of the results are incorrect. Instead of calculating min()s we do a
    simple < comparison with the abs() values of (t1, t2) and (t3, t4).

    Since the vector maths gives us points on a rectangle centered on a Cartesian grid at (0, 0)
    we need to transform |v| to be in the coordinate space of the image. We do this by
    translating |v| by (w/2, -h/2) and then flipping the y coordinates by multiplying by -1.

    Finally we clamp the values of x and y to 0 <= x <= width and 0 <= y <= height.

    NOTE: these coordinates are not completely right - some are off by a pixel or 2 because of
    rounding/precision errors. But these are good enough for what we need so this isn't a huge
    deal.
 */
private func edgeCoordinates(for angle: Double, in image: NSImage) -> CGPoint {
  let width = image.size.width
  let height = image.size.height

  // Calculate θ'
  let normalizedAngle = ((angle + 45) * .pi) / 180

  // Determine the signs for t1 and t4
  let t1Sign = cos(normalizedAngle) < 0 ? -1.0 : 1.0
  let t4Sign = sin(normalizedAngle) < 0 ? -1.0 : 1.0

  let t1 = t1Sign * (height / 2.0)
  let t2 = abs(sin(normalizedAngle)) < Double.ulpOfOne ? Double.infinity : (width * cos(normalizedAngle)) / (2 * abs(sin(normalizedAngle)))
  let t3 = abs(cos(normalizedAngle)) < Double.ulpOfOne ? Double.infinity : (height * sin(normalizedAngle)) / (2 * abs(cos(normalizedAngle)))
  let t4 = t4Sign * (width / 2.0)

  // Because of how the signs of cos() and sin() work out, we need to multiply the x value by -1 and leave y as-is. There's probably
  // some maths-y way to fix this but I'll leave this for now.
  let (xMultiplier, yMultiplier) = (x: -1.0, y: 1.0)

  // Translate the image centered at (0, 0) to the top-left being at (0, 0)
  let (xTranslation, yTranslation) = (width / 2.0, (-1 * height) / 2)

  let xTerm = abs(t1) < abs(t2) ? t1 : t2
  let yTerm = abs(t3) < abs(t4) ? t3 : t4

  let x = round(xMultiplier * xTerm + xTranslation)

  // Since the top left of the image is now at (0, 0), flip the y coordinates so that the bottom right of the image is at (width, height) on the grid.
  let y = -1 * (yMultiplier * yTerm + yTranslation)

  // Clamp x and y such that 0 <= x <= width and 0 <= y <= height and they are integral values.
  return CGPoint(
    x: round(min(max(x, 0.0), width)),
    y: round(min(max(y, 0.0), height))
  )
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
