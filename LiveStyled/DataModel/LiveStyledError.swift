//
//  LiveStyledError.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation

// Enum to capture different error scenario after making API call
public enum LiveStyledError: Error {
  case parsingFailed(details: String)
  case networkError(details: String)
  case configurationError(details: String)
  case serverError(details: String)
}
