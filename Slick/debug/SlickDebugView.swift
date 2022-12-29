//
//  SlickDebugControlsView.swift
//  Slick
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI

public struct SlickDebugView: View {
  @Environment(\.debugInfo) var debugInfo: DebugInfo?

  public init() {}

  public var body: some View {
    if let debugInfo = debugInfo {
      VStack {
        ScrollView {
          VStack(alignment: .leading) {
            HStack(spacing: 48) {
              DebugCornerView(
                label: "Top Left",
                sampledImage: debugInfo.topLeftSampledImage,
                colors: debugInfo.topLeftColors
              )
              DebugCornerView(
                label: "Top Right",
                sampledImage: debugInfo.topRightSampledImage,
                colors: debugInfo.topRightColors
              )
            }
            .padding(.bottom, 32)
            HStack(spacing: 48) {
              DebugCornerView(
                label: "Bottom Left",
                sampledImage: debugInfo.bottomLeftSampledImage,
                colors: debugInfo.bottomLeftColors
              )
              DebugCornerView(
                label: "Bottom Right",
                sampledImage: debugInfo.bottomRightSampledImage,
                colors: debugInfo.bottomRightColors
              )
            }
            Spacer()
          }
          .padding()
        }
      }
    }
  }
}
