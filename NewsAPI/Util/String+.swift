//
//  String+.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/22.
//

import Foundation

extension String {
    private static let apiInputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private static let realmInputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/M/d H시m분ss초"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private static let realmDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/M/d H시m분ss초"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private static let viewDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/M/d H시m분"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    // 날짜 형식 String으로 변환
    func formattedDateStringForView() -> String? {
        if let apiDate = String.apiInputDateFormatter.date(from: self) {
            return String.viewDateFormatter.string(from: apiDate)
        } else if let realmDate = String.realmInputDateFormatter.date(from: self) {
            return String.viewDateFormatter.string(from: realmDate)
        } else {
            return nil
        }
    }
    
    // Date를 String으로 변환 (Realm에 저장시 사용)
    static func dateToString(_ date: Date) -> String {
        return realmDateFormatter.string(from: date)
    }
    
    // String을 Date로 변환 (Realm에서 로드, 정렬시 사용)
    func toDate() -> Date? {
        return String.realmDateFormatter.date(from: self)
    }
    
}


extension String {
    func htmlToString() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        return attributedString?.string ?? self
    }
}
