//
//  AppDelegate.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          
          let config = Realm.Configuration(
              schemaVersion: 0,
              migrationBlock: { migration, oldSchemaVersion in
                  // 마이그레이션시 로직 추가
              },
              deleteRealmIfMigrationNeeded: false // 데이터베이스 삭제 방지
          )
          
          Realm.Configuration.defaultConfiguration = config
          
          // Realm 인스턴스 생성 및 스키마 버전 확인
          let realmService = RealmService()
          realmService.printRealmSchemaVersion()
          
          return true
      }

}

