//
//  ContentView.swift
//  AuroraDesigner
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI
import Aurora

let dividerWidth = Double(1)

struct ContentView: View {
  @State var selectedImage = "astronaut"
  @State var leftPaneWidth = 0.5

  @ViewBuilder var imageSelection: some View {
    VStack {
      Picker("Image", selection: $selectedImage) {
        ForEach(ExampleImages.allNames, id: \.self) {
          Text($0)
        }
      }
    }
  }

  @ViewBuilder var left: some View {
    VStack {
      imageSelection
        .padding()
      Divider()
      AuroraView(NSImage(named: selectedImage)) { nsImage in
        Image(nsImage: nsImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(4)
      }
    }
  }

  @ViewBuilder var right: some View {
    VStack(spacing: 0) {
      ScrollView {
        AuroraDebugSettingsView()
      }
      Divider()
      AuroraDebugView()
    }
  }

  var body: some View {
    AuroraDebugContainerView {
      GeometryReader { geometry in
        HStack(alignment: .top, spacing: 0) {
          left
            .frame(width: geometry.size.width * leftPaneWidth)
          Divider()
            .overlay(
              Rectangle()
                .fill(.clear)
                .frame(width: 10)
                .cursor(.resizeLeftRight)
                .gesture(
                  DragGesture(coordinateSpace: .named("stack"))
                    .onChanged { gesture in
                      let xValue = gesture.startLocation.x + gesture.translation.width
                      let percentage = xValue / geometry.size.width
                      leftPaneWidth = percentage
                    }
                )
            )
          right
            .frame(width: geometry.size.width * (1 - leftPaneWidth))
        }
        .coordinateSpace(name: "stack")
      }
    }
  }
}
