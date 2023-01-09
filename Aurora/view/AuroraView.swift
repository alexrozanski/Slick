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
  private let padding: Padding?
  private let imageView: ImageViewBuilder

  @StateObject private var viewModel: AuroraViewModel

  // Use this for writes to properties of objects on internalDataHolder.
  @Environment(\.internalDataHolder) private var internalDataHolder

  // Use these for reads as they will be reactive.
  @Environment(\.extractionConfig) private var extractionConfig
  @Environment(\.backgroundViewAppearance) private var backgroundAppearance
  @Environment(\.backgroundViewAnimationConfiguration) private var backgroundAnimationConfiguration

  private var debugInfo: DebugInfo? = nil

  public init(_ image: NSImage?, padding: Padding? = .all(96), @ViewBuilder imageView: @escaping ImageViewBuilder) {
    self.image = image
    self.padding = padding
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
          BackgroundView(
            viewModel: viewModel,
            appearance: backgroundAppearance,
            animationConfiguration: backgroundAnimationConfiguration
          )
        )
        .padding(padding?.edgeInsets ?? EdgeInsets())
    }
  }

  public struct Padding {
    public let top: CGFloat
    public let bottom: CGFloat
    public let leading: CGFloat
    public let trailing: CGFloat

    public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
      self.top = top
      self.bottom = bottom
      self.leading = leading
      self.trailing = trailing
    }

    public static func all(_ value: CGFloat) -> Padding {
      return Padding(top: value, leading: value, bottom: value, trailing: value)
    }

    public static func horizontal(_ value: CGFloat) -> Padding {
      return Padding(top: 0, leading: value, bottom: 0, trailing: value)
    }

    public static func vertical(_ value: CGFloat) -> Padding {
      return Padding(top: value, leading: 0, bottom: value, trailing: 0)
    }

    // Convenience functions to specify both horizontal/vertical padding and chain them.
    public func horizontal(_ value: CGFloat) -> Padding {
      return Padding(top: top, leading: value, bottom: bottom, trailing: value)
    }

    public func vertical(_ value: CGFloat) -> Padding {
      return Padding(top: value, leading: leading, bottom: value, trailing: trailing)
    }

    fileprivate var edgeInsets: EdgeInsets {
      return EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
  }
}
