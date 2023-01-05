//
//  NSImage+Bitmap.swift
//  Aurora
//
//  Created by Alex Rozanski on 29/12/2022.
//

import Cocoa

extension NSImage {
  /* Based on https://stackoverflow.com/a/43232455/75245 */
  func withImageData<T>(
    sourceRect: NSRect? = nil,
    outImage: inout NSImage?,
    body: (
      _ width: Int,
      _ height: Int,
      _ pixel: (_ x: Int, _ y: Int) -> ( red: Int, green: Int, blue: Int )
    ) -> T
  ) -> T? {
    let sourceRect = sourceRect ?? NSRect(origin: .zero, size: size)
    let width = Int(sourceRect.width)
    let height = Int(sourceRect.height)

    guard
      let colorSpace = CGColorSpace(name: CGColorSpace.genericRGBLinear),
      let cgContext = CGContext(
        data: nil,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
      ) else {
      return nil
    }

    let context = NSGraphicsContext(cgContext: cgContext, flipped: true)
    NSGraphicsContext.current = context
    defer {
      NSGraphicsContext.current = nil
    }

    let flippedSourceRect = NSRect(
      x: sourceRect.minX,
      y: size.height - sourceRect.height - sourceRect.minY,
      width: sourceRect.width,
      height: sourceRect.height
    )
    draw(at: .zero, from: flippedSourceRect, operation: .sourceOver, fraction: 1)

    guard let data = cgContext.data?.bindMemory(to: UInt32.self, capacity: width*height) else {
      return nil
    }

    let result = body(width, height, { x, y in
      let rgba = data[y * width + x]
      let r = Int((rgba & 0x000000ff) >> 0)
      let g = Int((rgba & 0x0000ff00) >> 8)
      let b = Int((rgba & 0x00ff0000) >> 16)

      return (r, g, b)
    })

    guard let image = cgContext.makeImage() else {
      return nil
    }

    outImage = NSImage(cgImage: image, size: NSSize(width: width, height: height))

    return result
  }
}
