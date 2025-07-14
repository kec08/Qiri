//
//  Date+Extensions.swift
//

import Foundation

extension Date {
  var formattedTime: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "hh:mm"
    return formatter.string(from: self)
  }
  
}
