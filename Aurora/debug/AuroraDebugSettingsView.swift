//
//  AuroraDebugSettingsView.swift
//  Aurora
//
//  Created by Alex Rozanski on 30/12/2022.
//

import SwiftUI

public struct AuroraDebugSettingsView: View {
  @Environment(\.internalDataHolder) var internalDataHolder
  @Environment(\.extractionConfig) var extractionConfig
  @Environment(\.backgroundViewAppearance) var backgroundViewAppearance

  @State private var labelWidth: CGFloat?

  public init() {}
  
  public var body: some View {
    return VStack(alignment: .leading) {
      Text("Image Extraction")
        .fontWeight(.semibold)
      imageExtractionSettings
      Text("Appearance")
        .fontWeight(.semibold)
        .padding(.top, 12)
      appearanceSettings
      Text("Animation")
        .fontWeight(.semibold)
        .padding(.top, 12)
      animationSettings

    }
    .environment(\.labelWidth, labelWidth)
    .onPreferenceChange(LabelWidthPreferenceKey.self) { newLabelWidth in
      labelWidth = newLabelWidth
    }
    .padding()
  }

  @ViewBuilder var imageExtractionSettings: some View {
    let samplePoints = Binding<Double>(
      get: { Double(extractionConfig.samplePoints) },
      set: { internalDataHolder.extractionConfig = internalDataHolder.extractionConfig.withSamplePoints(Int($0)) }
    )
    let gridSize = Binding<Double>(
      get: { Double(extractionConfig.gridSize) },
      set: { internalDataHolder.extractionConfig = internalDataHolder.extractionConfig.withGridSize(Int($0)) }
    )
    let sampleImageSideLength = Binding<Double>(
      get: { Double(extractionConfig.sampleImageSideLength) },
      set: { internalDataHolder.extractionConfig = internalDataHolder.extractionConfig.withSampleImageSideLength(Int($0)) }
    )

    VStack {
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
      SliderRow(
        label: "Sample Image Side Length",
        mode: .continuous,
        valueBinding: sampleImageSideLength,
        range: (10...200)
      )
    }
  }

  @ViewBuilder var appearanceSettings: some View {
    let blurColors = Binding<Bool>(
      get: { backgroundViewAppearance.blurColors },
      set: { internalDataHolder.backgroundViewAppearance = internalDataHolder.backgroundViewAppearance.withBlurColors($0) }
    )
    let opacity = Binding<Double>(
      get: { backgroundViewAppearance.opacity },
      set: { internalDataHolder.backgroundViewAppearance = internalDataHolder.backgroundViewAppearance.withOpacity($0) }
    )
    let blurRadius = Binding<Double>(
      get: { backgroundViewAppearance.blurRadius },
      set: { internalDataHolder.backgroundViewAppearance = internalDataHolder.backgroundViewAppearance.withBlurRadius($0) }
    )

    VStack {
      LabelledRow {
        Text("Blur Colors")
      } content: {
        Toggle("", isOn: blurColors)
      }
      SliderRow(
        label: "Opacity",
        mode: .continuous,
        valueBinding: opacity,
        range: (0...1)
      )
      SliderRow(
        label: "Blur Radius",
        mode: .continuous,
        valueBinding: blurRadius,
        range: (0...200)
      )
    }
  }

  @ViewBuilder var animationSettings: some View {
    let animateRotation = Binding<Bool>(
      get: { backgroundViewAppearance.animateRotation },
      set: { internalDataHolder.backgroundViewAppearance = internalDataHolder.backgroundViewAppearance.withAnimateRotation($0) }
    )
    let animateScale = Binding<Bool>(
      get: { backgroundViewAppearance.animateScale },
      set: { internalDataHolder.backgroundViewAppearance = internalDataHolder.backgroundViewAppearance.withAnimateScale($0) }
    )
    let animateOpacity = Binding<Bool>(
      get: { backgroundViewAppearance.animateOpacity },
      set: { internalDataHolder.backgroundViewAppearance = internalDataHolder.backgroundViewAppearance.withAnimateOpacity($0) }
    )

    VStack {
      LabelledRow {
        Text("Animate Rotation")
      } content: {
        Toggle("", isOn: animateRotation)
      }
      LabelledRow {
        Text("Animate Scale")
      } content: {
        Toggle("", isOn: animateScale)
      }
      LabelledRow {
        Text("Animate Opacity")
      } content: {
        Toggle("", isOn: animateOpacity)
      }
    }
  }
}

fileprivate struct LabelledRow<Label, Content>: View where Content: View, Label: View {
  @Environment(\.labelWidth) var labelWidth

  typealias LabelBuilder = () -> Label
  typealias ContentBuilder = () -> Content

  let label: LabelBuilder
  let content: ContentBuilder

  init(@ViewBuilder label: @escaping LabelBuilder, @ViewBuilder content: @escaping ContentBuilder) {
    self.label = label
    self.content = content
  }

  var body: some View {
    HStack {
      label()
        .background(
          GeometryReader { geometry in
            Color.clear.preference(
              key: LabelWidthPreferenceKey.self,
              value: geometry.size.width
            )
          }
        )
        .frame(width: labelWidth, alignment: .trailing)
      content()
      Spacer()
    }
  }
}

fileprivate struct SliderRow: View {
  enum Mode {
    case discrete(step: Double)
    case continuous
  }

  let label: String
  let mode: Mode
  let valueBinding: Binding<Double>
  let range: ClosedRange<Double>

  var body: some View {
    LabelledRow {
      Text(label)
    } content: {
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

fileprivate struct LabelWidthPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

fileprivate struct SliderLabelWidthPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

fileprivate extension ImageColorExtractor.ExtractionConfig {
  func withSamplePoints(_ newSamplePoints: Int) -> ImageColorExtractor.ExtractionConfig {
    return ImageColorExtractor.ExtractionConfig(
      samplePoints: newSamplePoints,
      gridSize: gridSize,
      sampleImageSideLength: sampleImageSideLength,
      colorPrioritization: colorPrioritization
    )
  }

  func withGridSize(_ newGridSize: Int) -> ImageColorExtractor.ExtractionConfig {
    return ImageColorExtractor.ExtractionConfig(
      samplePoints: samplePoints,
      gridSize: newGridSize,
      sampleImageSideLength: sampleImageSideLength,
      colorPrioritization: colorPrioritization
    )
  }

  func withSampleImageSideLength(_ newSampleImageSideLength: Int) -> ImageColorExtractor.ExtractionConfig {
    return ImageColorExtractor.ExtractionConfig(
      samplePoints: samplePoints,
      gridSize: gridSize,
      sampleImageSideLength: newSampleImageSideLength,
      colorPrioritization: colorPrioritization
    )
  }

  func withColorPrioritization(_ newColorPrioritization: ImageColorExtractor.ExtractionConfig.ColorPrioritization) -> ImageColorExtractor.ExtractionConfig {
    return ImageColorExtractor.ExtractionConfig(
      samplePoints: samplePoints,
      gridSize: gridSize,
      sampleImageSideLength: sampleImageSideLength,
      colorPrioritization: newColorPrioritization
    )
  }
}

fileprivate extension BackgroundView.Appearance {
  func withBlurColors(_ newBlurColors: Bool) -> BackgroundView.Appearance {
    return BackgroundView.Appearance(
      blurColors: newBlurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity
    )
  }

  func withOpacity(_ newOpacity: Double) -> BackgroundView.Appearance {
    return BackgroundView.Appearance(
      blurColors: blurColors,
      opacity: newOpacity,
      blurRadius: blurRadius,
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity
    )
  }

  func withBlurRadius(_ newBlurRadius: Double) -> BackgroundView.Appearance {
    return BackgroundView.Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: newBlurRadius,
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity
    )
  }

  func withAnimateRotation(_ newAnimateRotation: Bool) -> BackgroundView.Appearance {
    return BackgroundView.Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      animateRotation: newAnimateRotation,
      animateScale: animateScale,
      animateOpacity: animateOpacity
    )
  }

  func withAnimateScale(_ newAnimateScale: Bool) -> BackgroundView.Appearance {
    return BackgroundView.Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      animateRotation: animateRotation,
      animateScale: newAnimateScale,
      animateOpacity: animateOpacity
    )
  }

  func withAnimateOpacity(_ newAnimateOpacity: Bool) -> BackgroundView.Appearance {
    return BackgroundView.Appearance(
      blurColors: blurColors,
      opacity: opacity,
      blurRadius: blurRadius,
      animateRotation: animateRotation,
      animateScale: animateScale,
      animateOpacity: newAnimateOpacity
    )
  }
}

fileprivate struct LabelWidthKey: EnvironmentKey {
  static var defaultValue: CGFloat? = nil
}

fileprivate extension EnvironmentValues {
  var labelWidth: CGFloat? {
    get { self[LabelWidthKey.self] }
    set { self[LabelWidthKey.self] = newValue }
  }
}
