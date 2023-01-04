//
//  NSColor+Hex.swift
//  Slick
//
//  Created by Alex Rozanski on 03/01/2023.
//

import Cocoa
import ExceptionCatcher

extension NSColor {
  var safeRedComponent: CGFloat {
    do {
      return try ExceptionCatcher.catch { return redComponent }
    } catch {
      return usingColorSpace(.sRGB)?.redComponent ?? 0
    }
  }

  var safeGreenComponent: CGFloat {
    do {
      return try ExceptionCatcher.catch { return greenComponent }
    } catch {
      return usingColorSpace(.sRGB)?.greenComponent ?? 0
    }
  }

  var safeBlueComponent: CGFloat {
    do {
      return try ExceptionCatcher.catch { return blueComponent }
    } catch {
      return usingColorSpace(.sRGB)?.blueComponent ?? 0
    }
  }

  // Based on https://stackoverflow.com/a/32345031/75245
  var hexString: String {
    let red = Int(round(safeRedComponent * 0xFF))
    let green = Int(round(safeGreenComponent * 0xFF))
    let blue = Int(round(safeBlueComponent * 0xFF))
    return String(format: "#%02X%02X%02X", red, green, blue)
  }
}
