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
  @Environment(\.auroraAppearance) var appearance
  @Environment(\.auroraAnimationConfiguration) var animationConfiguration

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
      get: { appearance.blurColors },
      set: { internalDataHolder.appearance = internalDataHolder.appearance.withBlurColors($0) }
    )
    let opacity = Binding<Double>(
      get: { appearance.opacity },
      set: { internalDataHolder.appearance = internalDataHolder.appearance.withOpacity($0) }
    )
    let blurRadius = Binding<Double>(
      get: { appearance.blurRadius },
      set: { internalDataHolder.appearance = internalDataHolder.appearance.withBlurRadius($0) }
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
    VStack(spacing: 32) {
      rotationAnimationSettings
      scaleAnimationSettings
      opacityAnimationSettings
    }
  }

  @ViewBuilder var rotationAnimationSettings: some View {
    let animate = Binding<Bool>(
      get: { animationConfiguration.animateRotation },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withAnimateRotation($0) }
    )
    let duration = Binding<Double>(
      get: { animationConfiguration.rotationAnimationDuration },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withRotationAnimationDuration($0) }
    )
    let delay = Binding<ClosedRange<Double>>(
      get: { animationConfiguration.rotationAnimationDelayRange },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withRotationAnimationDelayRange($0) }
    )
    let centerOffset = Binding<ClosedRange<Double>>(
      get: { animationConfiguration.rotationCenterOffsetRange },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withRotationCenterOffsetRange($0) }
    )

    VStack {
      LabelledRow {
        Text("Animate Rotation")
      } content: {
        Toggle("", isOn: animate)
      }
      SliderRow(
        label: "Duration",
        mode: .continuous,
        valueBinding: duration,
        range: (0...20)
      )
      RangeSliderRow(
        label: "Delay",
        valueBinding: delay,
        range: 0...1
      )
      RangeSliderRow(
        label: "Center Offset",
        valueBinding: centerOffset,
        range: 0...0.1
      )
    }
  }

  @ViewBuilder var scaleAnimationSettings: some View {
    let animate = Binding<Bool>(
      get: { animationConfiguration.animateScale },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withAnimateScale($0) }
    )
    let duration = Binding<Double>(
      get: { animationConfiguration.scaleAnimationDuration },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withScaleAnimationDuration($0) }
    )
    let delay = Binding<ClosedRange<Double>>(
      get: { animationConfiguration.scaleAnimationDelayRange },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withScaleAnimationDelayRange($0) }
    )
    let minScale = Binding<ClosedRange<Double>>(
      get: { animationConfiguration.minScaleRange },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withMinScaleRange($0) }
    )
    let maxScale = Binding<ClosedRange<Double>>(
      get: { animationConfiguration.maxScaleRange },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withMaxScaleRange($0) }
    )

    VStack {
      LabelledRow {
        Text("Animate Scale")
      } content: {
        Toggle("", isOn: animate)
      }
      SliderRow(
        label: "Duration",
        mode: .continuous,
        valueBinding: duration,
        range: (0...20)
      )
      RangeSliderRow(
        label: "Delay",
        valueBinding: delay,
        range: 0...1
      )
      RangeSliderRow(
        label: "Min Scale",
        valueBinding: minScale,
        range: 0.5...0.99
      )
      RangeSliderRow(
        label: "Max Scale",
        valueBinding: maxScale,
        range: 1.01...1.5
      )
    }
  }

  @ViewBuilder var opacityAnimationSettings: some View {
    let animate = Binding<Bool>(
      get: { animationConfiguration.animateOpacity },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withAnimateOpacity($0) }
    )
    let duration = Binding<Double>(
      get: { animationConfiguration.opacityAnimationDuration },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withOpacityAnimationDuration($0) }
    )
    let delay = Binding<ClosedRange<Double>>(
      get: { animationConfiguration.opacityAnimationDelayRange },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withOpacityAnimationDelayRange($0) }
    )
    let minOpacity = Binding<ClosedRange<Double>>(
      get: { animationConfiguration.minOpacityRange },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withMinOpacityRange($0) }
    )
    let maxOpacity = Binding<ClosedRange<Double>>(
      get: { animationConfiguration.maxOpacityRange },
      set: { internalDataHolder.animationConfiguration = internalDataHolder.animationConfiguration.withMaxOpacityRange($0) }
    )

    VStack {
      LabelledRow {
        Text("Animate Opacity")
      } content: {
        Toggle("", isOn: animate)
      }
      SliderRow(
        label: "Duration",
        mode: .continuous,
        valueBinding: duration,
        range: (0...20)
      )
      RangeSliderRow(
        label: "Delay",
        valueBinding: delay,
        range: 0...1
      )
      RangeSliderRow(
        label: "Min Opacity",
        valueBinding: minOpacity,
        range: 0...0.49
      )
      RangeSliderRow(
        label: "Max Opacity",
        valueBinding: maxOpacity,
        range: 0.51...1
      )
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
        .frame(minWidth: labelWidth, alignment: .trailing)
      content()
      Spacer()
    }
  }
}

fileprivate struct RangeSliderRow: View {
  let label: String
  let valueBinding: Binding<ClosedRange<Double>>
  let range: ClosedRange<Double>

  var body: some View {
    LabelledRow {
      Text(label)
    } content: {
      HStack {
        RangeSliderView(
          value: valueBinding,
          range: range
        )
        HStack(spacing: 0) {
          Text("(")
          Text(valueBinding.wrappedValue.lowerBound, format: .number.precision(.fractionLength(2)))
          Text(", ")
          Text(valueBinding.wrappedValue.upperBound, format: .number.precision(.fractionLength(2)))
          Text(")")
        }
        .frame(width: 80, alignment: .leading)
      }
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
        .frame(width: 80, alignment: .leading)
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

fileprivate struct LabelWidthKey: EnvironmentKey {
  static var defaultValue: CGFloat? = nil
}

fileprivate extension EnvironmentValues {
  var labelWidth: CGFloat? {
    get { self[LabelWidthKey.self] }
    set { self[LabelWidthKey.self] = newValue }
  }
}
