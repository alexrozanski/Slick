//
//  SlickView.swift
//  
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI
import Combine

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

private class SlickViewModel: ObservableObject {
  private let imageColorExtractor = ImageColorExtractor()

  private let imageSubject: CurrentValueSubject<NSImage?, Never>
  private let configSubject: CurrentValueSubject<ImageColorExtractor.ExtractionConfig, Never>

  private var subscriptions = Set<AnyCancellable>()

  @Published var backgroundColors: [NSColor]?
  @Published var debugInfo: DebugInfo?

  init(initialImage: NSImage?) {
    imageSubject = CurrentValueSubject<NSImage?, Never>(initialImage)
    configSubject = CurrentValueSubject<ImageColorExtractor.ExtractionConfig, Never>(.default)

    let colorsAndDebugInfo = imageSubject
      .combineLatest(configSubject)
      .compactMap { (image, config) in
        guard let image = image else { return nil }
        return (image, config)
      }
      .map { (image, config) in
        Future<([NSColor], DebugInfo?), Never> { promise in
          self.imageColorExtractor.extractColors(from: image, config: config, completion: { colors, debugInfo in
            var wrappedColors = colors
            // Wrap the first colour around as backgroundColors is applied to an angular gradient.
            colors.first.map { wrappedColors.append($0) }
            promise(.success((colors, DebugInfo(colorExtractionDebugInfo: debugInfo))))
          }, completionQueue: .main)
        }
      }
      .switchToLatest()
      .share()

    colorsAndDebugInfo
      .map { (colors, _) in colors }
      .assign(to: \.backgroundColors, on: self)
      .store(in: &subscriptions)

    colorsAndDebugInfo
      .map { (_, debugInfo) in debugInfo }
      .assign(to: \.debugInfo, on: self)
      .store(in: &subscriptions)
  }

  func setImage(_ image: NSImage) {
    imageSubject.send(image)
  }

  func setConfig(_ config: ImageColorExtractor.ExtractionConfig) {
    configSubject.send(config)
  }
}

public struct SlickView<Image>: View where Image: View {
  public typealias ImageViewBuilder = (_ nsImage: NSImage) -> Image

  private let image: NSImage?
  private let appearance: Appearance
  private let imageView: ImageViewBuilder

  @StateObject private var viewModel: SlickViewModel

  // Use this for writes to properties of objects on internalDataHolder.
  @Environment(\.internalDataHolder) private var internalDataHolder
  // Use this for reads of extractionConfig values as this will be reactive.
  @Environment(\.extractionConfig) private var extractionConfig

  private var debugInfo: DebugInfo? = nil

  public init(_ image: NSImage?, @ViewBuilder imageView: @escaping ImageViewBuilder) {
    self.image = image
    self.appearance = .default
    self.imageView = imageView

    _viewModel = StateObject(wrappedValue: SlickViewModel(initialImage: image))
  }

  init(_ image: NSImage?, appearance: Appearance, @ViewBuilder imageView: @escaping ImageViewBuilder) {
    self.image = image
    self.appearance = appearance
    self.imageView = imageView

    _viewModel = StateObject(wrappedValue: SlickViewModel(initialImage: image))
  }

  @MainActor public var body: some View {
    if let image = image {
      imageView(image)
        .onChange(of: image) { newImage in
          viewModel.setImage(newImage)
        }
        .onReceive(internalDataHolder.$extractionConfig, perform: { newConfig in
          viewModel.setConfig(newConfig)
        })
        .onReceive(viewModel.$debugInfo, perform: { debugInfo in
          internalDataHolder.debugInfo = debugInfo
        })
        .padding(.horizontal, appearance.horizontalInsets)
        .padding(.vertical, appearance.verticalInsets)
        .background(backgroundGradient)
    }
  }

  @ViewBuilder private var backgroundGradient: some View {
    if let backgroundColors = viewModel.backgroundColors {
      Rectangle()
        .fill(AngularGradient(gradient: Gradient(
          colors: backgroundColors.map { Color(cgColor: $0.cgColor)}
        ), center: .center, angle: .degrees(225)))
        .opacity(appearance.blurColors ? appearance.opacity : 1)
        .blur(radius: appearance.blurColors ? appearance.blurRadius : 0)
        .blendMode(appearance.blurColors ? .normal : .normal)
    }
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
