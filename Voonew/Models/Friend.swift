//
//  Friend.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import Foundation

struct Friend: Identifiable, Hashable {
  let id: String

  let name: String
  let ppName: String

  init(id: String, name: String, ppName: String) {
    self.id = id
    self.name = name
    self.ppName = ppName
  }
}

// MARK: - Mock
  
extension Friend {
  static var all: [Self] = [
    .lancey, .travis, .kendrick, .carti, .kali, .yeat, .future, .thugger
  ]

  // User identity -- not included in randoms and all
  static var me: Self {
    .init(id: "me", name: "Tom", ppName: "tom")
  }

  static var lancey: Self {
    .init(id: .random(), name: "Lancey Foux", ppName: "lancey")
  }
  static var travis: Self {
    .init(id: .random(), name: "Travis Scott", ppName: "travis")
  }
  static var kendrick: Self {
    .init(id: .random(), name: "Kendrick Lamar", ppName: "kendrick")
  }
  static var carti: Self {
    .init(id: .random(), name: "Playboi Carti", ppName: "carti")
  }
  static var kali: Self {
    .init(id: .random(), name: "Kali Uchis", ppName: "kali")
  }
  static var yeat: Self {
    .init(id: .random(), name: "Yeat", ppName: "yeat")
  }
  static var thugger: Self {
    .init(id: .random(), name: "Young Thug", ppName: "thugger")
  }
  static var future: Self {
    .init(id: .random(), name: "Future", ppName: "future")
  }

  static func random(_ count: Int) -> [Self] {
    if count >= all.count {
      all
    } else if count <= 0 {
      []
    } else {
      Array(all.shuffled().dropLast(all.count - count))
    }
  }
}
