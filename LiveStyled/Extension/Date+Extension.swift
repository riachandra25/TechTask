//
//  Date+Extension.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation

extension Date {
  // convert date to formatted string
  func convertDateToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE KK:mm a"
    return dateFormatter.string(from: self)
  }

}
