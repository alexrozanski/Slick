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
        let orbSize = orbSize(for: geometry.size, appearance: appearance)
        ZStack {
          ForEach(backgroundOrbs, id: \.angle) { backgroundOrb in
            BackgroundOrb(viewModel: backgroundOrb, appearance: appearance)
              .frame(width: orbSize.width, height: orbSize.height)
              .offset(orbCenterOffset(for: geometry.size, angle: backgroundOrb.angle, appearance: appearance))
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}

private func orbSize(for viewSize: CGSize, appearance: Appearance) -> CGSize {
  let sideLength = min(viewSize.width, viewSize.height) * appearance.orbScaleFactor
  return CGSize(width: sideLength, height: sideLength)
}

private func orbCenterOffset(for size: CGSize, angle: Double, appearance: Appearance) -> CGSize {
  // Position the orbs around an imaginary rectangle that's centered in the center of the image but has
  // a size that is some fraction of the size of the image.
  let referenceSize = CGSize(width: size.width * appearance.orbSpacingFactor, height: size.height * appearance.orbSpacingFactor)
  let coords = edgeCoordinates(for: angle, inRectWithSize: referenceSize)
  return CGSize(
    width: coords.x - referenceSize.width / 2.0,
    height: coords.y - referenceSize.height / 2.0
  )
}
