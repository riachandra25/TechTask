//
//  Event.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation

struct Event: Decodable {

  /// The event ID
  let id: String?

  /// The event title
  let title: String?

  /// The event icon image URL
  let image: String?

  /// The event start date and time
  let startDate: Date?

  /// This is to  check if favourite button is selected
  var isFavourite: Bool = false

  init(id: String?, title: String?, image: String?, startDate: Date?, isFavorite: Bool) {
    self.id = id
    self.title = title
    self.image = image
    self.startDate = startDate
    self.isFavourite = isFavorite
  }
}

private extension Event {
  enum CodingKeys: String, CodingKey {
    case id, title, image, startDate
  }
}

