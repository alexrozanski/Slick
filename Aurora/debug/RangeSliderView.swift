//
//  RangeSliderView.swift
//  Aurora
//
//  Created by Alex Rozanski on 15/01/2023.
//

import SwiftUI

private let handleSideLength = Double(20)

struct RangeSliderView: View {
  let value: Binding<ClosedRange<Double>>
  let range: ClosedRange<Double>

  @State var minHandlePressed = false
  @State var maxHandlePressed = false

  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        VStack {
          Spacer()
          track
            .coordinateSpace(name: "track")
          Spacer()
        }
        Handle(sideLength: handleSideLength, pressed: minHandlePressed)
          .offset(x: handlePosition(for: value.wrappedValue.lowerBound, in: geometry.size.width))
          .gesture(
            LongPressGesture()
              .onChanged { _ in minHandlePressed = true }
          )
          .gesture(
            DragGesture(coordinateSpace: .named("track"))
              .onChanged { gesture in
                minHandlePressed = true

                let x = gesture.startLocation.x + gesture.translation.width
                let newLowerBound = min(max(range.lowerBound, convertToValueInRange(from: x, in: geometry.size.width)), value.wrappedValue.upperBound)
                value.wrappedValue = newLowerBound...value.wrappedValue.upperBound
              }
              .onEnded { _ in
                minHandlePressed = false
              }
          )
        Handle(sideLength: handleSideLength, pressed: maxHandlePressed)
          .offset(x: handlePosition(for: value.wrappedValue.upperBound, in: geometry.size.width))
          .gesture(
            LongPressGesture()
              .onChanged { _ in maxHandlePressed = true }
          )
          .gesture(
            DragGesture(coordinateSpace: .named("track"))
              .onChanged { gesture in
                maxHandlePressed = true

                let x = gesture.startLocation.x + gesture.translation.width
                let newUpperBound = max(min(convertToValueInRange(from: x, in: geometry.size.width), range.upperBound), value.wrappedValue.lowerBound)
                value.wrappedValue = value.wrappedValue.lowerBound...newUpperBound
              }
              .onEnded { _ in
                maxHandlePressed = false
              }
          )
      }
    }
  }

  @ViewBuilder private var track: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle()
          .fill(trackBackgroundColor)
          .frame(height: 4)
          .overlay(
            Rectangle()
              .strokeBorder(trackBorderColor, lineWidth: 1)
              .cornerRadius(2)
          )
        Rectangle()
          .fill(Color(cgColor: NSColor.controlAccentColor.cgColor))
          .frame(width: trackWidth(in: geometry.size.width), height: 4)
          .offset(x: trackPosition(for: value.wrappedValue.lowerBound, in: geometry.size.width))
      }
      .mask(Rectangle().cornerRadius(2))
    }
  }

  private func handlePosition(for value: Double, in width: Double) -> Double {
    return trackPosition(for: value, in: width - handleSideLength) + handleSideLength / 2
  }

  private func convertToValueInRange(from trackX: Double, in width: Double) -> Double {
    return (trackX / width) * (range.upperBound - range.lowerBound) + range.lowerBound
  }

  private func trackPosition(for value: Double, in width: Double) -> Double {
    return ((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * width
  }

  private func trackWidth(in availableWidth: Double) -> Double {
    return trackPosition(for: value.wrappedValue.upperBound, in: availableWidth) - trackPosition(for: value.wrappedValue.lowerBound, in: availableWidth)
  }

  private var trackBackgroundColor: Color {
    return colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.06)
  }

  private var trackBorderColor: Color {
    return colorScheme == .dark ? .clear : .black.opacity(0.03)
  }
}

fileprivate struct Handle: View {
  @Environment(\.colorScheme) var colorScheme

  let sideLength: Double
  let pressed: Bool

  var body: some View {
    Circle()
      .strokeBorder(borderColor, lineWidth: 0.5)
      .background(
        Circle()
          .fill(backgroundColor)
          .overlay(Circle().fill(pressed ? backgroundPressedColor : .clear))
          .shadow(color: shadowColor, radius: 0.5, y: 0.5)
      )
      .frame(width: sideLength, height: sideLength)
      .offset(x: sideLength * -0.5)
  }

  private var borderColor: Color {
    return colorScheme == .dark ? .clear : .black.opacity(0.15)
  }

  private var backgroundColor: Color {
    return colorScheme == .dark ? Color(white: 0.58) : .white
  }

  private var backgroundPressedColor: Color {
    return colorScheme == .dark ? Color(white: 0.65) : .black.opacity(0.04)
  }

  private var shadowColor: Color {
    return colorScheme == .dark ? .black.opacity(0.4) : .black.opacity(0.2)
  }
}
