//
//  ContentView.swift
//  AuroraDesigner
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI
import Aurora

struct ContentView: View {
  @State var selectedImage = "astronaut"

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
      AuroraDebugSettingsView()
      Divider()
      AuroraDebugView()
    }
  }

  var body: some View {
    AuroraDebugContainerView {
      HStack(alignment: .top, spacing: 0) {
        left
        Divider()
        right
      }
    }
  }
}
