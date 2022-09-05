//
//  getDate.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/05.
//

import Foundation

func getDate(date: Date) -> String? {
    let format = DateFormatter()
    format.locale = Locale(identifier: "ko_KR")
    let calendar = Calendar(identifier: .iso8601)
    if calendar.isDateInToday(date) {
        format.dateFormat = "a HH:mm"
    } else {
        let interval = Double(7)
        let todayYear = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let dateComponents = DateComponents(year: todayYear.year, month: todayYear.month, day: todayYear.day, hour: 00)
        let startDay = Date(timeInterval: -(86400 * (interval - 1)), since: calendar.date(from: dateComponents)!)
        if startDay <= date {
            format.dateFormat = "EEEE"
        } else {
            format.dateFormat = "yyyy. MM. dd a HH:mm"
        }
    }
    return format.string(from: date)
}
