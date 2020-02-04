//
//  UserDefaultConfig.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation

struct UserDefaultsConfig {
  struct Key {
    static let savedKey = "savedEventKey"
  }

  @UserDefault(Key.savedKey, defaultValue: [])
    static var savedEvents: [String]
}
