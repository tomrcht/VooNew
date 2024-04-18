//
//  String+Extension.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import Foundation

extension String {
  static func random() -> String {
    UUID().uuidString.lowercased()
  }
}
