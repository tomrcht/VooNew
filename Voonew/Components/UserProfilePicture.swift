//
//  UserProfilePicture.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import SwiftUI

struct UserProfilePicture: View {

  private let pictureName: String

  init(pictureName: String) {
    self.pictureName = pictureName
  }

  var body: some View {
    Image(pictureName)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .clipShape(Circle())
      .clipped()
      .background {
        //
      }
  }
}

#Preview {
  UserProfilePicture(pictureName: Friend.me.ppName)
}
