//
//  ContentView.swift
//  SlickExample
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI
import Slick

let images = ["astronaut", "frog"]

struct ContentView: View {
  @State var selectedImage = "astronaut"

  @ViewBuilder var imageSelection: some View {
    VStack {
      Picker("Image", selection: $selectedImage) {
        ForEach(images, id: \.self) {
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
      SlickView(NSImage(named: selectedImage)) { nsImage in
        Image(nsImage: nsImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(4)
      }
      .padding(32)
    }
  }

  @ViewBuilder var right: some View {
    VStack(spacing: 0) {
      SlickDebugSettingsView()
      Divider()
      SlickDebugView()
    }
  }

  var body: some View {
    SlickDebugContainerView {
      HStack(alignment: .top, spacing: 0) {
        left
        Divider()
        right
      }
    }
  }
}
