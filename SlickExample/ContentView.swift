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

  var body: some View {
    SlickDebugContainerView {
      HStack(alignment: .top, spacing: 0) {
        VStack {
          VStack {
            Picker("Image", selection: $selectedImage) {
              ForEach(images, id: \.self) {
                Text($0)
              }
            }
          }
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
        Divider()
        SlickDebugView()
      }
    }
  }
}
