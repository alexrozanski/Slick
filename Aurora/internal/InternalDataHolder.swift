//
//  InternalDataHolder.swift
//  Aurora
//
//  Created by Alex Rozanski on 30/12/2022.
//

import SwiftUI
import Combine

// Holds a internal data which can be injected into the environment at the top and used to propagate
// data upwards from below and shared amongst internal components.
internal class InternalDataHolder: ObservableObject {
  @Published var debugInfo: DebugInfo?
  @Published var extractionConfig: ImageColorExtractor.ExtractionConfig = .default()
  @Published var appearance: Appearance = .default()
  @Published var animationConfiguration: AnimationConfiguration = .default()
}

internal struct InternalDataHolderKey: EnvironmentKey {
  static var defaultValue = InternalDataHolder()
}

internal struct DebugInfoKey: EnvironmentKey {
  static var defaultValue: DebugInfo? = nil
}

internal struct ExtractionConfigKey: EnvironmentKey {
  static var defaultValue: ImageColorExtractor.ExtractionConfig = .default()
}

internal struct AuroraAppearanceKey: EnvironmentKey {
  static var defaultValue: Appearance = .default()
}

internal struct AuroraAnimationConfigurationKey: EnvironmentKey {
  static var defaultValue: AnimationConfiguration = .default()
}

internal extension EnvironmentValues {
  var internalDataHolder: InternalDataHolder {
    get { self[InternalDataHolderKey.self] }
    set { self[InternalDataHolderKey.self] = newValue }
  }

  var debugInfo: DebugInfo? {
    get { self[DebugInfoKey.self] }
    set { self[DebugInfoKey.self] = newValue }
  }

  var extractionConfig: ImageColorExtractor.ExtractionConfig {
    get { self[ExtractionConfigKey.self] }
    set { self[ExtractionConfigKey.self] = newValue }
  }

  var auroraAppearance: Appearance {
    get { self[AuroraAppearanceKey.self] }
    set { self[AuroraAppearanceKey.self] = newValue }
  }

  var auroraAnimationConfiguration: AnimationConfiguration {
    get { self[AuroraAnimationConfigurationKey.self] }
    set { self[AuroraAnimationConfigurationKey.self] = newValue }
  }
}
