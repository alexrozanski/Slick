//
//  AuroraDebugContainerView.swift
//  Aurora
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

public struct AuroraDebugContainerView<Content>: View where Content: View {
  private let content: () -> Content

  @StateObject private var internalDataHolder: InternalDataHolder = InternalDataHolder()

  public init(@ViewBuilder _ content: @escaping () -> Content) {
    self.content = content
  }

  public var body: some View {
    // For some reason exposing properties of internalDataHolder on the environment makes these reactive
    // to reads. This needs some more investigation.
    content()
      .environment(\.internalDataHolder, internalDataHolder)
      .environment(\.debugInfo, internalDataHolder.debugInfo)
      .environment(\.extractionConfig, internalDataHolder.extractionConfig)
      .environment(\.backgroundViewAppearance, internalDataHolder.backgroundViewAppearance)
  }
}
