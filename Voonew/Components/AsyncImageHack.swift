//
//  AsyncImageHack.swift
//  Voonew
//
//  Created by Tom on 17/04/2024.
//

import SwiftUI

struct AsyncImageHack<Content: View>: View{
    let url: URL?
    @ViewBuilder let content: (AsyncImagePhase) -> Content
    @State private var currentUrl: URL?

    var body: some View {
        AsyncImage(url: currentUrl, content: content)
        .onAppear {
            if currentUrl == nil {
                DispatchQueue.main.async {
                    currentUrl = url
                }
            }
        }
    }
}
