//
//  Context.swift
//  Voonew
//
//  Created by Tom on 16/04/2024.
//

import Foundation

@Observable
final class Context {
  private(set) var value: ViewContext = .today

  var isJournalSelected: Bool = false

  private var savedFriend: Friend?

  var profileName: String {
    if case let .profile(friend) = value {
      friend.name
    } else {
      "Profile"
    }
  }

  var isToday: Bool { value.isToday }
  var isProfile: Bool { value.isProfile }
  var isDetails: Bool { value.isDetails }

  func set(_ newContext: ViewContext) {
    guard value != newContext else { return }

    if case let .profile(friend) = value {
      savedFriend = friend
    }

    value = newContext
  }
}

extension Context {
  enum ViewContext: Equatable {
    case profile(Friend)
    case today
    case details(Journal)

    static func ==(lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case (.profile, .profile): true
      case (.today, .today): true
      case (.details, .details): true
      default: false
      }
    }

    var isToday: Bool {
      switch self {
      case .today: true
      default: false
      }
    }

    var isProfile: Bool {
      switch self {
      case .profile: true
      default: false
      }
    }

    var isDetails: Bool {
      switch self {
      case .details: true
      default: false
      }
    }
  }
}
