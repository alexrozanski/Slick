//
//  BackgroundOrb.swift
//  Aurora
//
//  Created by Alex Rozanski on 08/01/2023.
//

import SwiftUI

struct BackgroundOrb: View {
  let viewModel: BackgroundOrbViewModel
  let appearance: BackgroundView.Appearance

  var body: some View {
    Rotation(enabled: appearance.animateRotation, centerOffset: viewModel.rotationCenterOffset, animationDelay: viewModel.animationDelay) {
      Opacity(enabled: appearance.animateOpacity, minOpacity: viewModel.minOpacity, maxOpacity: viewModel.maxOpacity) {
        Scale(enabled: appearance.animateScale, minScale: viewModel.minScale, maxScale: viewModel.maxScale) {
          Circle()
            .fill(Color(cgColor: viewModel.color.cgColor))
            .blur(radius: appearance.blurColors ? appearance.blurRadius : 0)
            .transition(.opacity.animation(.easeIn(duration: 0.25)))
        }
      }
    }
  }
}

fileprivate typealias ContentBuilder<Content> = () -> Content

fileprivate struct ToggleAnimation: ViewModifier {
  let enabled: Bool
  @Binding var isAnimated: Bool
  let animation: Animation

  func body(content: Content) -> some View {
    content
      .onChange(of: enabled) { newValue in
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
          if newValue {
            withAnimation(animation) {
              isAnimated = newValue
            }
          } else {
            withAnimation(.linear(duration: 0)) {
              isAnimated = false
            }
          }
        }
      }
  }
}

fileprivate struct Rotation<Content>: View where Content: View {
  let enabled: Bool
  let centerOffset: CGPoint
  let animationDelay: Double
  let content: ContentBuilder<Content>

  private var animation: Animation {
    .linear(duration: 10.0).repeatForever(autoreverses: false).delay(animationDelay)
  }

  @State private var isRotating = false

  var body: some View {
    content()
      .rotationEffect(
        .degrees(isRotating ? 360 : 0),
        anchor: UnitPoint(x: centerOffset.x, y: centerOffset.y)
      )
      .onAppear {
        withAnimation(animation) {
          isRotating = true
        }
      }
      .modifier(ToggleAnimation(enabled: enabled, isAnimated: $isRotating, animation: animation))
  }
}

fileprivate struct Opacity<Content>: View where Content: View {
  let enabled: Bool
  let minOpacity: Double
  let maxOpacity: Double
  let content: ContentBuilder<Content>

  private var animation: Animation {
    .linear(duration: 10.0).repeatForever(autoreverses: true)
  }

  @State private var isAnimating = false

  var body: some View {
    content()
      .opacity(isAnimating ? minOpacity : maxOpacity)
      .onAppear {
        withAnimation(animation) {
          isAnimating = true
        }
      }
      .modifier(ToggleAnimation(enabled: enabled, isAnimated: $isAnimating, animation: animation))
  }
}

fileprivate struct Scale<Content>: View where Content: View {
  let enabled: Bool
  let minScale: Double
  let maxScale: Double
  let content: ContentBuilder<Content>

  private var animation: Animation {
    .linear(duration: 10.0).repeatForever(autoreverses: true)
  }

  @State private var isAnimating = false

  var body: some View {
    content()
      .scaleEffect(isAnimating ? minScale : maxScale)
      .onAppear {
        withAnimation(animation) {
          isAnimating = true
        }
      }
      .modifier(ToggleAnimation(enabled: enabled, isAnimated: $isAnimating, animation: animation))
  }
}
