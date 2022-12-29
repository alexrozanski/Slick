//
//  SlickView.swift
//  
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

public struct SlickView<Image>: View where Image: View {
  public typealias ImageViewBuilder = (_ nsImage: NSImage) -> Image

  private let image: NSImage?
  private let imageView: ImageViewBuilder

  public init(_ image: NSImage?, @ViewBuilder imageView: @escaping ImageViewBuilder) {
    self.image = image
    self.imageView = imageView
  }

  @MainActor public var body: some View {
    if let image = image {
      imageView(image)
        .padding()
        .background(.red)
    }
  }
}
