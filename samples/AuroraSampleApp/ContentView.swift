//
//  ContentView.swift
//  AuroraSampleApp
//
//  Created by Alex Rozanski on 06/01/2023.
//

import SwiftUI
import Aurora

struct ContentView: View {
  var body: some View {
    VStack {
      AuroraView(NSImage(named: "astronaut")) { image in
        Image(nsImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
    }
    .padding()
  }
}
