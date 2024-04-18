//
//  Journal.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import Foundation

struct Journal: Identifiable, Hashable {
  let id: String

  let date: Date
  let owner: Friend
  let name: String?
  let entries: [Entry]
}

extension Journal {
  struct Entry: Identifiable, Hashable {
    let id: String

    let author: Friend
    let photos: [Photo]
  }
}

extension Journal {
  static func mockName() -> String {
    [
      "Miami at the speed of light",
      "Rainy day",
      "My Birthday!! 🎉",
      "A day in Le Marais",
      "Exams :( 💪",
      "Wedding day! 💜",
    ].randomElement()!
  }
}
