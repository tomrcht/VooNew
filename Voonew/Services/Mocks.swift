//
//  Mocks.swift
//  Voonew
//
//  Created by Tom on 16/04/2024.
//

import Foundation

enum Mocks {
  static func photos() -> [Photo] {
    [
      .init(url: URL(string: "https://images.unsplash.com/photo-1713342941873-f80792de1a81?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDF8NnNNVmpUTFNrZVF8fGVufDB8fHx8fA%3D%3D")),
      .init(url: URL(string: "https://images.unsplash.com/photo-1712315458167-f04b14f13d17?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDJ8NnNNVmpUTFNrZVF8fGVufDB8fHx8fA%3D%3D")),
      .init(url: URL(string: "https://images.unsplash.com/photo-1713322985754-80286a087746?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDExfDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D")),
      .init(url: URL(string: "https://images.unsplash.com/photo-1712313190872-80a41b864f3b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDR8NnNNVmpUTFNrZVF8fGVufDB8fHx8fA%3D%3D")),
      .init(url: URL(string: "https://images.unsplash.com/photo-1713338018831-62f304267c26?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDEwfDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D")),
      .init(url: URL(string: "https://images.unsplash.com/photo-1561848355-890d054dc55a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE3fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D")),
      .init(url: URL(string: "https://images.unsplash.com/photo-1703076798954-ef7de811069d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE5fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D")),
      .init(url: URL(string: "https://images.unsplash.com/photo-1712959670199-4bc3e645a0db?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDIyfDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D")),
      .init(url: URL(string: "https://images.unsplash.com/photo-1507614498949-edbabc86a14f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDM4fDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D")),
      .init(url: URL(string: "https://images.unsplash.com/photo-1713151516865-9d9d3130de35?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDUwfDZzTVZqVExTa2VRfHxlbnwwfHx8fHw%3D")),
    ]
  }

  static func comments() -> [Comment] {
    [
      .init(id: .random(), author: .carti, content: "Lamborghini parked outside, it's purple like lean"),
      .init(id: .random(), author: .future, content: "I just met your girl in some Gucci flip flops"),
      .init(id: .random(), author: .kali, content: "Tienes que aceptar que ahora soy un recuerdo"),
      .init(id: .random(), author: .yeat, content: "Every time they drop an album, all they music pancake, it flops"),
      .init(id: .random(), author: .lancey, content: "My young boy right beside of me, ready to redrum"),
      .init(id: .random(), author: .me, content: "Thanks I guess ?"),
    ]
  }
}
