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
    VStack {
      Picker("Image", selection: $selectedImage) {
        ForEach(images, id: \.self) {
          Text($0)
        }
      }
      HStack {
        SlickView(NSImage(named: selectedImage)) { nsImage in
          Image(nsImage: nsImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
        }
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
