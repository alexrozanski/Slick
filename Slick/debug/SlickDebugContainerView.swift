//
//  SlickDebugContainerView.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

public struct SlickDebugContainerView<Content>: View where Content: View {
  private let content: () -> Content

  @StateObject private var debugInfoHolder: DebugInfoHolder = DebugInfoHolder()

  public init(@ViewBuilder _ content: @escaping () -> Content) {
    self.content = content
  }

  public var body: some View {
    content()
      .environment(\.debugInfoHolder, debugInfoHolder)
      .environment(\.debugInfo, debugInfoHolder.debugInfo)
  }
}
