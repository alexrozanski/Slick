//
//  BinaryFloatingPoint+Formatting.swift
//  Aurora
//
//  Created by Alex Rozanski on 28/01/2023.
//

import Foundation

extension BinaryFloatingPoint {
  func formattedNumber(fractionLength: Int) -> String {
    return self.formatted(FloatingPointFormatStyle<Double>.number.precision(.fractionLength(fractionLength)))
  }
}
