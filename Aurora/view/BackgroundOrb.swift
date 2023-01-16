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
  let animationConfiguration: AnimationConfiguration

  var body: some View {
    Rotation(configuration: animationConfiguration, centerOffset: viewModel.rotationCenterOffset, animationDelay: viewModel.rotationAnimationDelay) {
      Opacity(configuration: animationConfiguration, minOpacity: viewModel.minOpacity, maxOpacity: viewModel.maxOpacity) {
        Scale(configuration: animationConfiguration, minScale: viewModel.minScale, maxScale: viewModel.maxScale) {
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
  let configuration: AnimationConfiguration
  let centerOffset: CGPoint
  let animationDelay: Double
  let content: ContentBuilder<Content>

  @State private var isRotating = false

  private func animation(duration: Double, delay: Double) -> Animation {
    return .linear(duration: duration).repeatForever(autoreverses: false).delay(delay)
  }

  var body: some View {
    content()
      .rotationEffect(
        .degrees(isRotating ? 360 : 0),
        anchor: UnitPoint(x: centerOffset.x, y: centerOffset.y)
      )
      .animation(animation(duration: configuration.rotationAnimationDuration, delay: animationDelay), value: isRotating)
      .onAppear {
        isRotating = true
      }
      .modifier(
        UpdateAnimation(
          enabled: configuration.animateRotation,
          duration: configuration.rotationAnimationDuration,
          delay: animationDelay,
          isAnimated: $isRotating,
          animationBuilder: animation
        )
      )
  }
}

fileprivate struct Opacity<Content>: View where Content: View {
  let configuration: AnimationConfiguration
  let minOpacity: Double
  let maxOpacity: Double
  let content: ContentBuilder<Content>

  private func animation(duration: Double, delay: Double) -> Animation {
    return .linear(duration: duration).repeatForever(autoreverses: true)
  }

  @State private var isAnimating = false

  var body: some View {
    content()
      .opacity(isAnimating ? minOpacity : maxOpacity)
      .onAppear {
        withAnimation(animation(duration: configuration.opacityAnimationDuration, delay: 0)) {
          isAnimating = true
        }
      }
      .modifier(
        UpdateAnimation(
          enabled: configuration.animateOpacity,
          duration: configuration.opacityAnimationDuration,
          delay: 0,
          isAnimated: $isAnimating,
          animationBuilder: animation
        )
      )
  }
}

fileprivate struct Scale<Content>: View where Content: View {
  let configuration: AnimationConfiguration
  let minScale: Double
  let maxScale: Double
  let content: ContentBuilder<Content>

  private func animation(duration: Double, delay: Double) -> Animation {
    return .linear(duration: duration).repeatForever(autoreverses: true)
  }

  @State private var isAnimating = false

  var body: some View {
    content()
      .scaleEffect(isAnimating ? minScale : maxScale)
      .onAppear {
        withAnimation(animation(duration: configuration.scaleAnimationDuration, delay: 0)) {
          isAnimating = true
        }
      }
      .modifier(
        UpdateAnimation(
          enabled: configuration.animateScale,
          duration: configuration.scaleAnimationDuration,
          delay: 0,
          isAnimated: $isAnimating,
          animationBuilder: animation
        )
      )
  }
}
