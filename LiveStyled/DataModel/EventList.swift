//
//  EventList.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation

struct EventList: Decodable {

  /// The current page in the list
  let page: Int?

  /// The page size for each page
  let pageSize: Int?

  /// Total number of events
  let total: Int?

  /// The event list
  let items: [Event]?

  init(page: Int?, pageSize: Int?, total: Int?, items: [Event]?) {
    self.page = page
    self.pageSize = pageSize
    self.total = total
    self.items = items
  }
}
