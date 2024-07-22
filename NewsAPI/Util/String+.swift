//
//  String+.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/22.
//

import Foundation

extension String {
    private static let inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private static let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/M/d HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    func formattedDateString() -> String? {
        guard let date = String.inputDateFormatter.date(from: self) else {
            return nil
        }
        return String.outputDateFormatter.string(from: date)
    }
    
}

// 예시 사용
//let originalDateString = "Thu, 18 Jul 2024 14:28:00 +0900"
//if let formattedDateString = originalDateString.formattedDateString() {
//    print(formattedDateString) // 출력: "7/18/2024 14시28분"
//} else {
//    print("날짜 형식이 잘못되었습니다.")
//}
