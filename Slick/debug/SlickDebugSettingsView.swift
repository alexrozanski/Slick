//
//  SlickDebugSettingsView.swift
//  Slick
//
//  Created by Alex Rozanski on 30/12/2022.
//

import SwiftUI

public struct SlickDebugSettingsView: View {
  @Environment(\.internalDataHolder) var internalDataHolder
  @Environment(\.extractionConfig) var extractionConfig

  public init() {}
  
  public var body: some View {
    let samplePoints = Binding<Double>(
      get: { Double(extractionConfig.samplePoints) },
      set: { internalDataHolder.extractionConfig = internalDataHolder.extractionConfig.withSamplePoints(Int($0)) }
    )
    let gridSize = Binding<Double>(
      get: { Double(extractionConfig.gridSize) },
      set: { internalDataHolder.extractionConfig = internalDataHolder.extractionConfig.withGridSize(Int($0)) }
    )

    return VStack {
      SliderRow(
        label: "Sample Points",
        mode: .discrete(step: 1),
        valueBinding: samplePoints,
        range: (4...16)
      )
      SliderRow(
        label: "Grid Size",
        mode: .discrete(step: 1),
        valueBinding: gridSize,
        range: (1...10)
      )
    }
    .padding()
  }
}

private struct SliderRow: View {
  enum Mode {
    case discrete(step: Double)
    case continuous
  }

  let label: String
  let mode: Mode
  let valueBinding: Binding<Double>
  let range: ClosedRange<Double>

  var body: some View {
    HStack {
      Text(label)
      switch mode {
      case .discrete(step: let step):
        Slider(value: valueBinding, in: range, step: step)
      case .continuous:
        Slider(value: valueBinding, in: range)
      }
      Text(valueBinding.wrappedValue, format: .number.precision(.fractionLength(1)))
        .frame(width: 50, alignment: .leading)
    }
  }
}
