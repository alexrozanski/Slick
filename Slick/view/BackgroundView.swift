//
//  BackgroundView.swift
//  Slick
//
//  Created by Alex Rozanski on 03/01/2023.
//

import SwiftUI

internal struct BackgroundView: View {
  @ObservedObject var viewModel: SlickViewModel

  @State var showColors = false

  var body: some View {
    colors
      .onChange(of: viewModel.backgroundColors, perform: { _ in
        withAnimation {
          showColors = viewModel.backgroundColors != nil
        }
      })
  }

  @ViewBuilder private var colors: some View {
    if let backgroundColors = viewModel.backgroundColors, showColors {
      GeometryReader { geometry in
        ZStack {
          ForEach(backgroundColors, id: \.color) { backgroundColor in
            Circle()
              .fill(Color(cgColor: backgroundColor.color.cgColor))
              .frame(width: orbSize(for: geometry.size).width, height: orbSize(for: geometry.size).height)
              .offset(orbCenterOffset(for: geometry.size, angle: backgroundColor.angle))
              .opacity(0.5)
              .blur(radius: 100)
              .transition(.opacity.animation(.easeIn(duration: 0.25)))
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
