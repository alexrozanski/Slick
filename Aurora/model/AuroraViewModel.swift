//
//  AuroraViewModel.swift
//  Aurora
//
//  Created by Alex Rozanski on 03/01/2023.
//

import Combine
import Cocoa

internal class AuroraViewModel: ObservableObject {
  private let imageColorExtractor = ImageColorExtractor()

  private let imageSubject: CurrentValueSubject<NSImage?, Never>
  private let configSubject: CurrentValueSubject<ImageColorExtractor.ExtractionConfig, Never>

  private var subscriptions = Set<AnyCancellable>()

  @Published var backgroundOrbs: [BackgroundOrbViewModel]?
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
        Future<([ImageColorExtractor.BackgroundColor], DebugInfo?), Never> { promise in
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
      .map { (colors, _) in colors.map { BackgroundOrbViewModel(backgroundColor: $0) } }
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
    configSubject.send(config)
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
