//
//  Photo.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import Foundation

struct Photo: Identifiable, Hashable {
  let id: String
  let url: URL?

  init(id: String = UUID().uuidString, url: URL?) {
    self.id = id
    self.url = url
  }
}

// MARK: - Parsing

extension Photo {
  init(from unsplashPhoto: UnsplashPhoto) {
    self.id = unsplashPhoto.id
    self.url = unsplashPhoto.regularURL
  }
}
