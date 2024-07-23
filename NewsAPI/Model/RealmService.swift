//
//  RealmService.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/23.
//

import Foundation
import RxSwift
import RealmSwift

struct RealmService {
    let realm = try? Realm()
    
    //    func loadReadNews() -> Observable<[News]> {
    //        return Observable<Results<News>>.create { observer in
    //            if let results = self.realm?.objects(News.self) {
    //                observer.onNext(results)
    //            }
    //            return Disposables.create()
    //        }
    //        .map { results in
    //            return Array(results)
    //        }
    //    }
    
    
    func loadReadNews() -> Observable<[News]> {
        return Observable.create { [self] observer in
            // Realm의 Results 객체 가져오기
            guard let realm = realm else {
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Realm instance"]))
                return Disposables.create()
            }
            
            let results = realm.objects(News.self)
            
            // NotificationToken로 Results 변화 감지
            let notificationToken = results.observe { changes in
                switch changes {
                case .initial(let initialResults):
                    observer.onNext(Array(initialResults))
                case .update(_, let deletions, let insertions, let modifications):
                    // 데이터 변경 시 업데이트 제공
                    var updatedResults = Array(results)
                    
                    // 여기서 필요한 경우, 변경 사항 처리
                    // 예를 들어, 삭제, 삽입, 수정된 항목을 처리할 수 있습니다.
                    observer.onNext(updatedResults)
                case .error(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                notificationToken.invalidate()
            }
        }
    }
    
    func saveReadNews(news: News) {
        let now = String.fromDate(Date())
        news.timeStamp = now
        
        do {
            //            print(Realm.Configuration.defaultConfiguration.fileURL!.path)
            try realm?.write {
                realm?.add(news)
            }
        } catch {
            print("Error saving news: \(error.localizedDescription)")
        }
    }
    
    func deleteReadNews(news: News) {
        
    }
    
    
    
    
}


