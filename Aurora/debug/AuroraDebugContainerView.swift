//
//  AuroraDebugContainerView.swift
//  Aurora
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

public struct AuroraDebugContainerView<Content>: View where Content: View {
  private let content: () -> Content

  @StateObject private var environmentConfigurationHolder: EnvironmentConfigurationHolder = EnvironmentConfigurationHolder()

  public init(@ViewBuilder _ content: @escaping () -> Content) {
    self.content = content
  }

  public var body: some View {
    // For some reason exposing properties of environmentConfigurationHolder on the environment makes these reactive
    // to reads. This needs some more investigation.
    content()
      .environment(\.environmentConfigurationHolder, environmentConfigurationHolder)
      .environment(\.debugInfo, environmentConfigurationHolder.debugInfo)
      .environment(\.extractionConfig, environmentConfigurationHolder.extractionConfig)
      .environment(\.auroraAppearance, environmentConfigurationHolder.appearance)
      .environment(\.auroraAnimationConfiguration, environmentConfigurationHolder.animationConfiguration)
  }
}
