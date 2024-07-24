//
//  APIService.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/22.
//

import Foundation
import RxSwift
import RxCocoa

struct APIService {
    let baseURL = "https://openapi.naver.com/v1/search/news.json"
    
    var currentStartNum: BehaviorSubject<Int> = BehaviorSubject(value: 1)
    var totalCount = PublishSubject<Int>()
    
    func fetchNews(start: Int = 1) -> Observable<[News]> {
        
        let urlString = baseURL + "?query=한국" + "&start=\(start)" // + "&display=100"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(APIError.notValidURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(Secrets.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.addValue(Secrets.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        return URLSession.shared.rx.response(request: urlRequest)
            .map { (response: HTTPURLResponse, data: Data) -> DataEntity in
                guard !data.isEmpty else {
                    print("No Content")
                    throw APIError.noContent
                }
                
                guard (200...299).contains(response.statusCode) else {
                    print("Bad Status Code: \(response.statusCode)")
                    throw APIError.badStatus(code: response.statusCode)
                }
                
                let dataEntity = try JSONDecoder().decode(DataEntity.self, from: data)
                
                let currentStartNum = try self.currentStartNum.value()
                if currentStartNum != dataEntity.start {
                    self.currentStartNum.onNext(dataEntity.start)
                }
                self.totalCount.onNext(dataEntity.total)
                return dataEntity
            }
            .map { dataEntity -> [News] in
                return dataEntity.items.map { item in
                    News(
                        id: UUID().uuidString,
                        title: item.title.htmlToString(),
                        content: item.description.htmlToString(),
                        date: item.pubDate.formattedDateStringForView() ?? item.pubDate,
                        url: item.link,
                        timeStamp: ""
                    )
                }
            }
            .catch { error in
                print("Error: \(error)")
                return Observable.error(error)
            }
    }
    
}


// MARK: - APIError
extension APIService {
    enum APIError : Error {
        case notValidURL
        case noContent
        case decodingError
        case badStatus(code: Int)
        case unknown(_ err: Error?)
        
        var errorMessage : String {
            switch self {
            case .notValidURL :       return "올바른 URL 형식이 아닙니다."
            case .noContent :           return "데이터가 없습니다."
            case .decodingError :       return "디코딩 에러입니다."
            case .badStatus(let code):  return "에러 상태코드: \(code)"
            case .unknown(let err):     return "알 수 없는 에러입니다. \n \(String(describing: err))"
            }
        }
    }
    
}
