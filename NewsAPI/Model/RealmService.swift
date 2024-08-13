//
//  RealmService.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/23.
//

import Foundation
import RxSwift
import RealmSwift

protocol RealmServiceProtocol {
    func loadReadNews() -> Observable<[News]>
    func saveReadNews(news: News)
    func deleteReadNews(news: News)
}

struct RealmService: RealmServiceProtocol {
    var realm = try? Realm()
    
    func loadReadNews() -> Observable<[News]> {
        return Observable.create { [self] observer in
            guard let realm = realm else {
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Realm instance"]))
                return Disposables.create()
            }
            
            let noti = realm.objects(News.self).observe { changes in
                switch changes {
                case .initial(let results):
                    observer.onNext(Array(results))
                case .update(let results, _, _, _):
                    observer.onNext(Array(results))
                case .error(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                noti.invalidate()
            }
        }
        .map { (newsArray: [News]) -> [News] in
            return newsArray.sorted(by: { news1, news2 in
                guard let date1 = news1.timeStamp.toDate(), let date2 = news2.timeStamp.toDate() else {
                    return false
                }
                return date1 > date2
            })
        }
    }
    
    
    func saveReadNews(news: News) {
        let now = String.dateToString(Date())
        
        do {
            try realm?.write {
                let newsCount = realm?.objects(News.self).count ?? 0
                
                if newsCount >= 30 {
                    if let oldestNews = realm?.objects(News.self).sorted(byKeyPath: "timeStamp", ascending: true).first {
                        realm?.delete(oldestNews)
                    }
                }
                
                if let existingNews = realm?.object(ofType: News.self, forPrimaryKey: news.url) {
                    existingNews.timeStamp = now
                } else {
                    news.timeStamp = now
                    realm?.add(news)
                }
            }
        } catch {
            print("Error saving news: \(error.localizedDescription)")
        }
    }
    
    
    func deleteReadNews(news: News) {
        do {
            try realm?.write {
                if let existingNews = realm?.object(ofType: News.self, forPrimaryKey: news.url) {
                    realm?.delete(existingNews)
                }
            }
        } catch {
            print("Error deleting memoData: \(error)")
            
        }
    }
    
    
    func printRealmSchemaVersion() {
         if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
             do {
                 let version = try schemaVersionAtURL(fileURL)
                 print("Schema Version: \(version)") // 현재 스키마 버전 출력
             } catch {
                 print("Error fetching schema version: \(error)")
             }
         } else {
             print("Failed to get Realm file URL")
         }
     }
    
    
}


