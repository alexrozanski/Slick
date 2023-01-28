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
    ZStack {
      Opacity(viewModel: viewModel) {
        Scale(viewModel: viewModel) {
          GeometryReader { geometry in
            Rotation(viewModel: viewModel, size: geometry.size) {
              ZStack {
                Rectangle()
                  .fill(Color(cgColor: viewModel.color.cgColor))
                  .cornerRadius((geometry.size.width / 2) * appearance.orbRoundness)
                  .blur(radius: appearance.blurColors ? appearance.blurRadius : 0)
                  .opacity(appearance.opacity)
                  .transition(.opacity.animation(.easeIn(duration: 0.25)))
                if appearance.showDebugOverlays {
                  Circle()
                    .fill(.yellow)
                    .frame(width: 5, height: 5)
                }
              }
            }
          }
        }
      }
      if appearance.showDebugOverlays {
        Circle()
          .fill(.red)
          .frame(width: 5, height: 5)
        Circle()
          .stroke(.blue)
          .frame(width: viewModel.rotationPathRadius * 2, height: viewModel.rotationPathRadius * 2)
          .offset(CGSize(width: viewModel.rotationCenterOffset.width, height: viewModel.rotationCenterOffset.height))
        Circle()
          .fill(.blue)
          .frame(width: 5, height: 5)
          .offset(CGSize(width: viewModel.rotationCenterOffset.width, height: viewModel.rotationCenterOffset.height))
      }
    }
  }
}

fileprivate typealias ContentBuilder<Content> = () -> Content

fileprivate struct Rotation<Content>: NSViewRepresentable where Content: View {
  let viewModel: BackgroundOrbViewModel
  let size: CGSize
  let content: ContentBuilder<Content>

  private let animationKey = "pathAnimation"

  class Coordinator {
    struct AnimationProperties: Equatable {
      let enabled: Bool
      let duration: Double
      let delay: Double
      let pathRadius: Double
      let centerOffset: CGSize
    }

    var hostingController: NSHostingController<Content>?
    var animationProperties: AnimationProperties

    init(animationProperties: AnimationProperties) {
      self.animationProperties = animationProperties
    }
  }

  func makeCoordinator() -> Coordinator {
    // Read and set the animation properties in makeNSView() as these may not be correct yet.
    return Coordinator(animationProperties: .init(enabled: true, duration: 0, delay: 0, pathRadius: 0, centerOffset: .zero))
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

    guard properties.enabled else { return }

    let initialPath = CGMutablePath()
    initialPath.addArc(center: .zero, radius: properties.pathRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

    // Adjust `angle` so it sweeps anticlockwise, then offset to match the path's angle.
    let adjustedAngle = (360 - viewModel.angle) - 405
    let rotation = CGAffineTransform(rotationAngle: adjustedAngle * (.pi / 180))
    let translation = CGAffineTransform(translationX: properties.centerOffset.width, y: -properties.centerOffset.height)

    var transform = rotation.concatenating(translation)
    let path = initialPath.copy(using: &transform)

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
    return .init(
      enabled: viewModel.animateRotation,
      duration: viewModel.rotationAnimationDuration,
      delay: viewModel.rotationAnimationDelay,
      pathRadius: viewModel.rotationPathRadius,
      centerOffset: viewModel.rotationCenterOffset
    )
  }
}

fileprivate struct Opacity<Content>: View where Content: View {
  let viewModel: BackgroundOrbViewModel
  let content: ContentBuilder<Content>

  private func animation(duration: Double, delay: Double) -> Animation {
    return .linear(duration: duration).repeatForever(autoreverses: false).delay(viewModel.opacityAnimationDelay)
  }

  @State private var step = Double(0)

  var body: some View {
    StepAnimatedView(step: step, startingStep: viewModel.opacityAnimationStartingStep, behavior: .oscillating) { animatedStep in
      content()
        .opacity(animatedStep * (viewModel.maxOpacity - viewModel.minOpacity) + viewModel.minOpacity)
        .onAppear {
          withAnimation(animation(duration: viewModel.opacityAnimationDuration, delay: viewModel.opacityAnimationDelay)) {
            step = 1
          }
        }
        .modifier(
          UpdateAnimation(
            enabled: viewModel.animateOpacity,
            duration: viewModel.opacityAnimationDuration,
            delay: viewModel.opacityAnimationDelay,
            step: $step,
            animationBuilder: animation
          )
        )
    }
  }
}

fileprivate struct Scale<Content>: View where Content: View {
  let viewModel: BackgroundOrbViewModel
  let content: ContentBuilder<Content>

  private func animation(duration: Double, delay: Double) -> Animation {
    return .linear(duration: duration).repeatForever(autoreverses: true).delay(delay)
  }

  @State private var step = Double(0)

  var body: some View {
    StepAnimatedView(step: step, startingStep: viewModel.scaleAnimationStartingStep, behavior: .oscillating) { animatedStep in
      content()
        .scaleEffect(
          animatedStep * (viewModel.maxScale - viewModel.minScale) + viewModel.minScale,
          anchor: viewModel.scaleAnchor
        )
        .onAppear {
          withAnimation(animation(duration: viewModel.scaleAnimationDuration, delay: viewModel.scaleAnimationDelay)) {
            step = 1
          }
        }
        .modifier(
          UpdateAnimation(
            enabled: viewModel.animateScale,
            duration: viewModel.scaleAnimationDuration,
            delay: viewModel.scaleAnimationDelay,
            step: $step,
            animationBuilder: animation
          )
        )
    }
  }
}
