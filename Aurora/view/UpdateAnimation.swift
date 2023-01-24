//
//  UpdateAnimation.swift
//  Aurora
//
//  Created by Alex Rozanski on 24/01/2023.
//

import SwiftUI

internal struct UpdateAnimation: ViewModifier {
  let enabled: Bool
  let duration: Double
  let delay: Double

  // Ranges from 0...1
  @Binding var step: Double

  let animationBuilder: (_ duration: Double, _ delay: Double) -> Animation

  func body(content: Content) -> some View {
    content
      .onChange(of: duration) { newDuration in
        updateAnimation(enabled: enabled, duration: newDuration, delay: delay)
      }
      .onChange(of: delay) { newDelay in
        updateAnimation(enabled: enabled, duration: duration, delay: newDelay)
      }
      .onChange(of: enabled) { newValue in
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
          if newValue {
            withAnimation(animationBuilder(duration, delay)) {
              step = 1
            }
          } else {
            withAnimation(.linear(duration: 0)) {
              step = 0
            }
          }
        }
      }
  }

  private func updateAnimation(enabled: Bool, duration: Double, delay: Double) {
    var transaction = Transaction()
    transaction.disablesAnimations = true
    withTransaction(transaction) {
      guard enabled else { return }

      // Changing the animation with the new duration requires a property change, so
      // flip `isAnimated` quickly.
      withAnimation(.linear(duration: 0)) { step = 0 }
      withAnimation(animationBuilder(duration, delay).delay(0.1)) { step = 1 }
    }
  }
}
