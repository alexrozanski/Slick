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
    Opacity(viewModel: viewModel) {
      Scale(viewModel: viewModel) {
        GeometryReader { geometry in
          Rotation(viewModel: viewModel, size: geometry.size) {
            Rectangle()
              .fill(Color(cgColor: viewModel.color.cgColor))
              .cornerRadius((geometry.size.width / 2) * appearance.orbRoundness)
              .blur(radius: appearance.blurColors ? appearance.blurRadius : 0)
              .opacity(appearance.opacity)
              .transition(.opacity.animation(.easeIn(duration: 0.25)))
          }
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
              isAnimated = true
            }
          } else {
            withAnimation(.linear(duration: 0)) {
              isAnimated = false
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
      withAnimation(.linear(duration: 0)) { isAnimated = false }
      withAnimation(animationBuilder(duration, delay).delay(0.1)) { isAnimated = true }
    }
  }
}

fileprivate struct Rotation<Content>: NSViewRepresentable where Content: View {
  let viewModel: BackgroundOrbViewModel
  let size: CGSize
  let content: ContentBuilder<Content>

  private let animationKey = "pathAnimation"

  class Coordinator {
    struct AnimationProperties: Equatable {
      let duration: Double
      let delay: Double
    }

    var hostingController: NSHostingController<Content>?
    var animationProperties: AnimationProperties

    init(animationProperties: AnimationProperties) {
      self.animationProperties = animationProperties
    }
  }

  func makeCoordinator() -> Coordinator {
    // Read and set the animation properties in makeNSView() as these may not be correct yet.
    return Coordinator(animationProperties: .init(duration: 0, delay: 0))
  }

  func makeNSView(context: Context) -> NSView {
    let view = NSView(frame: NSRect(origin: .zero, size: size))
    view.translatesAutoresizingMaskIntoConstraints = false

    let hostingController = NSHostingController(rootView: content())
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingController.view)
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
      hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      hostingController.view.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])

    context.coordinator.hostingController = hostingController
    context.coordinator.animationProperties = currentAnimationProperties()

    view.wantsLayer = true
    view.layer?.masksToBounds = false

    replaceAnimation(with: context.coordinator.animationProperties, in: view)

    return view
  }

  func updateNSView(_ nsView: NSView, context: Context) {
    context.coordinator.hostingController?.rootView = content()

    let newAnimationProperties = currentAnimationProperties()
    if newAnimationProperties != context.coordinator.animationProperties {
      context.coordinator.animationProperties = newAnimationProperties
      replaceAnimation(with: newAnimationProperties, in: nsView)
    }
  }

  private func replaceAnimation(with properties: Rotation<Content>.Coordinator.AnimationProperties, in nsView: NSView) {
    nsView.layer?.removeAnimation(forKey: animationKey)

    let circlePathRadius = Double(10)
    let path = CGPath(
      ellipseIn: CGRect(
        origin: CGPoint(x: -circlePathRadius, y: -0.5 * circlePathRadius),
        size: CGSize(width: circlePathRadius, height: circlePathRadius)),
      transform: nil
    )

    // It's easier to use CA to move along this path rather than rebuild this in SwiftUI.
    let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
    animation.duration = properties.duration
    animation.repeatCount = .greatestFiniteMagnitude
    animation.path = path
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards
    animation.timingFunction = CAMediaTimingFunction(name: .linear)
    // Prevent delay between repeats
    animation.calculationMode = .paced
    animation.beginTime = CACurrentMediaTime() + properties.delay

    nsView.layer?.add(animation, forKey: animationKey)
  }

  private func currentAnimationProperties() -> Rotation<Content>.Coordinator.AnimationProperties {
    return .init(duration: viewModel.rotationAnimationDuration, delay: viewModel.rotationAnimationDelay)
  }
}

fileprivate struct Opacity<Content>: View where Content: View {
  let viewModel: BackgroundOrbViewModel
  let content: ContentBuilder<Content>

  private func animation(duration: Double, delay: Double) -> Animation {
    return .linear(duration: duration).repeatForever(autoreverses: true).delay(viewModel.opacityAnimationDelay)
  }

  @State private var isAnimated = false

  var body: some View {
    content()
      .opacity(isAnimated ? viewModel.maxOpacity : viewModel.minOpacity)
      .onAppear {
        withAnimation(animation(duration: viewModel.opacityAnimationDuration, delay: viewModel.opacityAnimationDelay)) {
          isAnimated = true
        }
      }
      .modifier(
        UpdateAnimation(
          enabled: viewModel.animateOpacity,
          duration: viewModel.opacityAnimationDuration,
          delay: viewModel.opacityAnimationDelay,
          isAnimated: $isAnimated,
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

  @State private var isAnimated = false

  var body: some View {
    content()
      .scaleEffect(isAnimated ? viewModel.minScale : viewModel.maxScale, anchor: viewModel.scaleAnchor)
      .onAppear {
        withAnimation(animation(duration: viewModel.scaleAnimationDuration, delay: viewModel.scaleAnimationDelay)) {
          isAnimated = true
        }
      }
      .modifier(
        UpdateAnimation(
          enabled: viewModel.animateScale,
          duration: viewModel.scaleAnimationDuration,
          delay: viewModel.scaleAnimationDelay,
          isAnimated: $isAnimated,
          animationBuilder: animation
        )
      )
  }
}
