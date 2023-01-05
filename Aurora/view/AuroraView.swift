//
//  AuroraView.swift
//  
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI
import Combine

public struct AuroraView<Image>: View where Image: View {
  public typealias ImageViewBuilder = (_ nsImage: NSImage) -> Image

  private let image: NSImage?
  private let imageView: ImageViewBuilder

  @StateObject private var viewModel: AuroraViewModel

  // Use this for writes to properties of objects on internalDataHolder.
  @Environment(\.internalDataHolder) private var internalDataHolder

  // Use these for reads as they will be reactive.
  @Environment(\.extractionConfig) private var extractionConfig
  @Environment(\.backgroundViewAppearance) private var backgroundAppearance

  private var debugInfo: DebugInfo? = nil

  public init(_ image: NSImage?, @ViewBuilder imageView: @escaping ImageViewBuilder) {
    self.image = image
    self.imageView = imageView

    _viewModel = StateObject(wrappedValue: AuroraViewModel(initialImage: image))
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
        .background(
          BackgroundView(viewModel: viewModel, appearance: backgroundAppearance)
        )
    }
  }
}
