//
//  PositionDebugColorView.swift
//  Aurora
//
//  Created by Alex Rozanski on 28/01/2023.
//

import SwiftUI

struct PositionDebugColorView: View {
  let color: NSColor

  @State var isPresented = false

  var body: some View {
    Circle()
      .fill(Color(cgColor: color.cgColor))
      .frame(width: 20, height: 20)
      .contextMenu {
        Text(color.hexString)
        Divider()
        Button("Copy color") {
          let pasteboard = NSPasteboard.general
          pasteboard.prepareForNewContents(with: [])
          pasteboard.setString(color.hexString, forType: .string)
        }
      }
      .onHover { isHovered in
        isPresented = isHovered
      }
      .popover(isPresented: $isPresented) {
        ColorMetricsView(color: color)
          .padding()
      }
  }
}

fileprivate struct ColorMetricsView: View {
  let color: NSColor

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(color.hexString).fontWeight(.semibold)
          .padding(.bottom, 2)
        Spacer()
        Circle()
          .fill(Color(cgColor: color.cgColor))
      }
      HStack(spacing: 16) {
        VStack(alignment: .leading, spacing: 2) {
          ColorMetricView(label: "R", value: (color.safeRedComponent * 255).formattedNumber(fractionLength: 0))
          ColorMetricView(label: "G", value: (color.safeGreenComponent * 255).formattedNumber(fractionLength: 0))
          ColorMetricView(label: "B", value: (color.safeBlueComponent * 255).formattedNumber(fractionLength: 0))
        }

        VStack(alignment: .leading, spacing: 2) {
          ColorMetricView(label: "H", value: "\((color.hueComponent * 360).formattedNumber(fractionLength: 0))°")
          ColorMetricView(label: "S", value: (color.saturationComponent * 100).formattedNumber(fractionLength: 0))
          ColorMetricView(label: "B", value: (color.brightnessComponent * 100).formattedNumber(fractionLength: 0))
        }
      }
    }
  }
}

fileprivate struct ColorMetricView: View {
  let label: String
  let value: String

  var body: some View {
    HStack(spacing: 0) {
      Text("\(label):").fontWeight(.semibold)
        .frame(width: 20, alignment: .leading)
      Text(value)
    }
  }
}
