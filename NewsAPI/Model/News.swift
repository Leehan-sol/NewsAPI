//
//  News.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/22.
//

import Foundation

struct News {
    let title: String
    let description: String
    let date: String
    let url: String
}

// Realm에도 동일하게 저장
// 저장한 순서대로 RecordView에 그리기
// 저장할때 해당 url이 있는지 확인 후, 있으면 삭제 후 다시 저장 (기존 Record에서 삭제, 끌올)
