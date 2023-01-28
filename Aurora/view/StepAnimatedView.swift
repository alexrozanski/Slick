//
//  StepAnimatedView.swift
//  Aurora
//
//  Created by Alex Rozanski on 28/01/2023.
//

import SwiftUI

/*
 * Provides an animatable step value between 0...1 which can be used to derive further
 * animated values such as opacity, scale etc.
 *
 * Supports both repeating values (i.e. 0 -> 0.5 -> 0.99 -> 0) or oscillating values
 * (i.e. 0 -> 0.5 -> 0.99 -> 0.5 -> 0).
 */
internal struct StepAnimatedView<Content>: View, Animatable where Content: View {
  enum StepBehavior {
    case repeating
    case oscillating
  }

  var step: Double
  let startingStep: Double
  let behavior: StepBehavior
  let content: (_ animatedStep: Double) -> Content

  var animatableData: Double {
    get { step }
    set { step = newValue }
  }

  var body: some View {
    switch behavior {
    case .repeating:
      content((step + startingStep).truncatingRemainder(dividingBy: 1.0))
    case .oscillating:
      // Since we use `startingStep` to provide a starting step value, constrain our current step to
      // be within 0...1.
      let currentStep = (step + startingStep / 2).truncatingRemainder(dividingBy: 1.0)
      // Since we start anywhere from 0...1 and want to cycle from an output value of 0...1 smoothly
      // repeatedly, map our `currentStep` value onto `y = 2 * (0.5 - |x - 0.5|)` which will cycle from 0...1
      // smoothly no matter where we start (since it is symmetrical about the y-axis from 0...1):
      //
      //    ^
      //   1|  ^
      //    | / \
      //    |/   \
      //----+--+--+>
      //    | 0.5 1
      let animatedStep = 1 - 2 * abs(currentStep - 0.5)
      content(animatedStep)
    }
  }
}
