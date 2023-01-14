//
//  BackgroundView.swift
//  Aurora
//
//  Created by Alex Rozanski on 03/01/2023.
//

import SwiftUI

internal struct BackgroundView: View {
  @ObservedObject var viewModel: AuroraViewModel
  let appearance: Appearance
  let animationConfiguration: AnimationConfiguration

  @State var showColors = false

  var body: some View {
    orbs
      .onChange(of: viewModel.backgroundOrbs) { _ in
        withAnimation {
          showColors = viewModel.backgroundOrbs != nil
        }
      }
  }

  @ViewBuilder private var orbs: some View {
    if let backgroundOrbs = viewModel.backgroundOrbs, showColors {
      GeometryReader { geometry in
        ZStack {
          ForEach(backgroundOrbs, id: \.angle) { backgroundOrb in
            BackgroundOrb(viewModel: backgroundOrb, appearance: appearance, animationConfiguration: animationConfiguration)
              .frame(width: orbSize(for: geometry.size).width, height: orbSize(for: geometry.size).height)
              .offset(orbCenterOffset(for: geometry.size, angle: backgroundOrb.angle))
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}

private func orbSize(for viewSize: CGSize) -> CGSize {
  let sideLength = min(viewSize.width, viewSize.height) * 0.65
  return CGSize(width: sideLength, height: sideLength)
}

private func orbCenterOffset(for size: CGSize, angle: Double) -> CGSize {
  let referenceSize = CGSize(width: size.width * 0.6, height: size.height * 0.6)
  let coords = edgeCoordinates(for: angle, inRectWithSize: referenceSize)
  return CGSize(
    width: coords.x - referenceSize.width / 2.0,
    height: coords.y - referenceSize.height / 2.0
  )
}
