//
//  DebugInfoHolder.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

// Holds a DebugInfo instance which can be injected into the environment at the top and used to propagate
// DebugInfo instances upwards from below.
internal class DebugInfoHolder: ObservableObject {
  @Published var debugInfo: DebugInfo?
}

internal struct DebugInfoHolderKey: EnvironmentKey {
  static var defaultValue = DebugInfoHolder()
}

internal extension EnvironmentValues {
  var debugInfoHolder: DebugInfoHolder {
    get { self[DebugInfoHolderKey.self] }
    set { self[DebugInfoHolderKey.self] = newValue }
  }
}
