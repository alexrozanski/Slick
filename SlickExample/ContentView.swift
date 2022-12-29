//
//  ContentView.swift
//  SlickExample
//
//  Created by Alex Rozanski on 29/12/2022.
//

import SwiftUI
import Slick

struct ContentView: View {
  var body: some View {
    HStack {
      SlickView(NSImage(named: "astronaut")) { nsImage in
        Image(nsImage: nsImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
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
