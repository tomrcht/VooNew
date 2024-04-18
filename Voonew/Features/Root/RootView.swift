//
//  RootView.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import SwiftUI

struct RootView: View {

  @State private var navigationPath = NavigationPath()
  @State private var viewContext = Context()

  var body: some View {
    NavigationStack(path: $navigationPath) {
      HomeView(navigationPath: $navigationPath)
        .environment(viewContext)
    }
  }
}

#Preview {
  RootView()
}
