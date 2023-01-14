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

  @ViewBuilder var left: some View {
    VStack {
      VStack {
        Picker("Image", selection: $selectedImage) {
          ForEach(ExampleImages.allNames, id: \.self) {
            Text($0)
          }
        }
      }
        .padding()
      Divider()
      Spacer()
      AuroraView(NSImage(named: selectedImage)) { nsImage in
        Image(nsImage: nsImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(4)
      }
      Spacer()
    }
  }

  @ViewBuilder var right: some View {
    VSplitView {
      ScrollView {
        AuroraDebugSettingsView()
      }
      AuroraDebugView()
    }
  }

  var body: some View {
    AuroraDebugContainerView {
      HSplitView {
        left
        right
      }
    }
  }
}
