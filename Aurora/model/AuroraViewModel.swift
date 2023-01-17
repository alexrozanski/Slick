//
//  AuroraViewModel.swift
//  Aurora
//
//  Created by Alex Rozanski on 03/01/2023.
//

import Combine
import SwiftUI

internal class AuroraViewModel: ObservableObject {
  var animationConfiguration: AnimationConfiguration? {
    didSet {
      animationConfigurationSubject.send(animationConfiguration)
    }
  }

  private let imageColorExtractor = ImageColorExtractor()

  private let imageSubject: CurrentValueSubject<NSImage?, Never>
  private let extractionConfigurationSubject: CurrentValueSubject<ImageColorExtractor.ExtractionConfig, Never>
  private let animationConfigurationSubject: CurrentValueSubject<AnimationConfiguration?, Never>

  private var subscriptions = Set<AnyCancellable>()

  @Published var backgroundOrbs: [BackgroundOrbViewModel]?
  @Published var debugInfo: DebugInfo?

  init(initialImage: NSImage?) {
    imageSubject = CurrentValueSubject<NSImage?, Never>(initialImage)
    extractionConfigurationSubject = CurrentValueSubject<ImageColorExtractor.ExtractionConfig, Never>(.default())
    animationConfigurationSubject = CurrentValueSubject<AnimationConfiguration?, Never>(nil)

    let colorsAndDebugInfo = imageSubject
      .combineLatest(extractionConfigurationSubject)
      .compactMap { (image, config) in
        guard let image = image else { return nil }
        return (image, config)
      }
      .map { (image, config) in
        Future<([ImageColorExtractor.ExtractedColor], DebugInfo?), Never> { promise in
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
      .combineLatest(animationConfigurationSubject)
      .compactMap { values -> (([ImageColorExtractor.ExtractedColor], DebugInfo?), AnimationConfiguration)? in
        let (colorsAndDebugInfo, animationConfiguration) = values
        guard let animationConfiguration else { return nil }
        return (colorsAndDebugInfo, animationConfiguration)
      }
      .map { values in
        let (colorsAndDebugInfo, animationConfiguration) = values
        let (colors, _) = colorsAndDebugInfo
        return colors.map { BackgroundOrbViewModel(backgroundColor: $0, animationConfiguration: animationConfiguration) }
      }
      .assign(to: \.backgroundOrbs, on: self)
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
    extractionConfigurationSubject.send(config)
  }
}

fileprivate extension DebugInfo {
  convenience init(colorExtractionDebugInfo debugInfo: ImageColorExtractor.ExtractionDebugInfo) {
    self.init(
      positions: debugInfo
        .points
        .sorted(by: { $0.angle < $1.angle })
        .map {
          DebugInfo.PositionInfo(
            angle: $0.angle,
            image: $0.sampledImage,
            colors: $0.topColors,
            edgeCoordinates: $0.edgeCoordinates,
            focusPoint: UnitPoint(x: $0.focusPoint.x, y: $0.focusPoint.y)
          )
        }
    )
  }
}
