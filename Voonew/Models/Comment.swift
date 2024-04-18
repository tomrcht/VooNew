//
//  Comment.swift
//  Voonew
//
//  Created by Tom on 16/04/2024.
//

import Foundation

struct Comment: Identifiable, Hashable {
  let id: String

  let author: Friend
  let content: String
}
