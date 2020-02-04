//
//  RequestResult.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation

// Enum to capture API response - Success or Failure
public enum RequestResult<T> {
  case success(item: T)
  case failure(error: LiveStyledError)
}


