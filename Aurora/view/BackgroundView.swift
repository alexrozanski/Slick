//
//  BackgroundView.swift
//  Aurora
//
//  Created by Alex Rozanski on 03/01/2023.
//

import SwiftUI

internal struct BackgroundView: View {
  // Keep this struct internal -- expose a higher-level appearance API if configuratiojn is desired.
  internal struct Appearance {
    static var `default` = Appearance(
      blurColors: true,
      opacity: 0.6,
      blurRadius: 48.3
    )

    let blurColors: Bool
    let opacity: Double
    let blurRadius: Double
  }

  @ObservedObject var viewModel: AuroraViewModel
  let appearance: Appearance

  @State var showColors = false
  @State var rotationSteps = [Double]()
  @State var scaleSteps = [Double]()
  @State var opacitySteps = [Double]()

  var body: some View {
    orbs
      .onChange(of: viewModel.backgroundOrbs) { _ in
        rotationSteps = viewModel.backgroundOrbs.map { Array(repeating: 0, count: $0.count) } ?? []
        scaleSteps = viewModel.backgroundOrbs.map { Array(repeating: 0, count: $0.count) } ?? []
        opacitySteps = viewModel.backgroundOrbs.map { Array(repeating: 0, count: $0.count) } ?? []
        withAnimation {
          showColors = viewModel.backgroundOrbs != nil
        }
      }
  }

  @ViewBuilder private var orbs: some View {
    if let backgroundOrbs = viewModel.backgroundOrbs, showColors {
      GeometryReader { geometry in
        ZStack {
          ForEach(Array(backgroundOrbs.enumerated()), id: \.element) { index, backgroundOrb in
            VStack {
              Circle()
                .fill(Color(cgColor: backgroundOrb.color.cgColor))
                .frame(width: orbSize(for: geometry.size).width, height: orbSize(for: geometry.size).height)
                .opacity(opacitySteps[index] * (backgroundOrb.maxOpacity - backgroundOrb.minOpacity) + backgroundOrb.minOpacity)
                .blur(radius: appearance.blurColors ? appearance.blurRadius : 0)
                .transition(.opacity.animation(.easeIn(duration: 0.25)))
                .rotationEffect(
                  .degrees(rotationSteps[index] * 360.0),
                  anchor: UnitPoint(x: backgroundOrb.rotationCenterOffset.x, y: backgroundOrb.rotationCenterOffset.y)
                )
                .scaleEffect(scaleSteps[index] * (backgroundOrb.maxScale - backgroundOrb.minScale) + backgroundOrb.minScale)
            }
            .offset(orbCenterOffset(for: geometry.size, angle: backgroundOrb.angle))
            .onAppear {
              withAnimation(
                .linear(duration: 10.0)
                .repeatForever(autoreverses: false)
                .delay(backgroundOrb.animationDelay)
              ) {
                rotationSteps[index] = 1
              }
              withAnimation(
                .linear(duration: 10.0)
                .repeatForever(autoreverses: true)
              ) {
                scaleSteps[index] = 1
                opacitySteps[index] = 1
              }
            }
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