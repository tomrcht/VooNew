//
//  UnsplashPhoto.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import Foundation

struct UnsplashPhoto: Identifiable, Decodable {
  let id: String
  let urls: URLs

  var regularURL: URL? {
    URL(string: urls.regular)
  }
}

extension UnsplashPhoto {
  struct URLs: Decodable {
    let regular: String
  }
}
