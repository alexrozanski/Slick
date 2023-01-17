//
//  BackgroundOrb.swift
//  Aurora
//
//  Created by Alex Rozanski on 08/01/2023.
//

import SwiftUI

struct BackgroundOrb: View {
  let viewModel: BackgroundOrbViewModel
  let appearance: Appearance

  var body: some View {
    Rotation(viewModel: viewModel) {
      Opacity(viewModel: viewModel) {
        Scale(viewModel: viewModel) {
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

fileprivate struct UpdateAnimation: ViewModifier {
  let enabled: Bool
  let duration: Double
  let delay: Double
  @Binding var isAnimated: Bool
  let animationBuilder: (_ duration: Double, _ delay: Double) -> Animation

  func body(content: Content) -> some View {
    content
      .onChange(of: duration) { newDuration in
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
          guard enabled else { return }

          // Changing the animation with the new duration requires a property change, so
          // flip `isAnimated` quickly.
          withAnimation(.linear(duration: 0)) { isAnimated = false }
          withAnimation(animationBuilder(newDuration, delay).delay(0.1)) { isAnimated = true }
        }
      }
      .onChange(of: delay) { newDelay in
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
          guard enabled else { return }

          // Changing the animation with the new duration requires a property change, so
          // flip `isAnimated` quickly.
          withAnimation(.linear(duration: 0)) { isAnimated = false }
          withAnimation(animationBuilder(duration, newDelay).delay(0.1)) { isAnimated = true }
        }
      }
      .onChange(of: enabled) { newValue in
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
          if newValue {
            withAnimation(animationBuilder(duration, delay)) {
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
  let viewModel: BackgroundOrbViewModel
  let content: ContentBuilder<Content>

  @State private var isRotating = false

  private func animation(duration: Double, delay: Double) -> Animation {
    return .linear(duration: duration).repeatForever(autoreverses: false).delay(delay)
  }

  var body: some View {
    content()
      .rotationEffect(
        .degrees(isRotating ? 360 : 0),
        anchor: UnitPoint(x: viewModel.rotationCenterOffset.x, y: viewModel.rotationCenterOffset.y)
      )
      .animation(animation(duration: viewModel.rotationAnimationDuration, delay: viewModel.rotationAnimationDelay), value: isRotating)
      .onAppear {
        isRotating = true
      }
      .modifier(
        UpdateAnimation(
          enabled: viewModel.animateRotation,
          duration: viewModel.rotationAnimationDuration,
          delay: viewModel.rotationAnimationDelay,
          isAnimated: $isRotating,
          animationBuilder: animation
        )
      )
  }
}

fileprivate struct Opacity<Content>: View where Content: View {
  let viewModel: BackgroundOrbViewModel
  let content: ContentBuilder<Content>

  private func animation(duration: Double, delay: Double) -> Animation {
    return .linear(duration: duration).repeatForever(autoreverses: true).delay(delay)
  }

  @State private var isAnimating = false

  var body: some View {
    content()
      .opacity(isAnimating ? viewModel.minOpacity : viewModel.maxOpacity)
      .onAppear {
        withAnimation(animation(duration: viewModel.opacityAnimationDuration, delay: viewModel.opacityAnimationDelay)) {
          isAnimating = true
        }
      }
      .modifier(
        UpdateAnimation(
          enabled: viewModel.animateOpacity,
          duration: viewModel.opacityAnimationDuration,
          delay: viewModel.opacityAnimationDelay,
          isAnimated: $isAnimating,
          animationBuilder: animation
        )
      )
  }
}

fileprivate struct Scale<Content>: View where Content: View {
  let viewModel: BackgroundOrbViewModel
  let content: ContentBuilder<Content>

  private func animation(duration: Double, delay: Double) -> Animation {
    return .linear(duration: duration).repeatForever(autoreverses: true).delay(delay)
  }

  @State private var isAnimating = false

  var body: some View {
    content()
      .scaleEffect(isAnimating ? viewModel.minScale : viewModel.maxScale, anchor: viewModel.scaleAnchor)
      .onAppear {
        withAnimation(animation(duration: viewModel.scaleAnimationDuration, delay: viewModel.scaleAnimationDelay)) {
          isAnimating = true
        }
      }
      .modifier(
        UpdateAnimation(
          enabled: viewModel.animateScale,
          duration: viewModel.scaleAnimationDuration,
          delay: viewModel.scaleAnimationDelay,
          isAnimated: $isAnimating,
          animationBuilder: animation
        )
      )
  }
}
