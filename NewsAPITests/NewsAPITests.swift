//
//  NewsAPITests.swift
//  NewsAPITests
//
//  Created by hansol on 2024/08/03.
//

import XCTest
import RxSwift
@testable import NewsAPI

final class NewsAPITests: XCTestCase {
    private var viewModel: ListViewModel!
    private var disposeBag: DisposeBag!
    private let mockAPIService = MockAPIService()
    
    override func setUp() {
        super.setUp()
        
        viewModel = ListViewModel(apiService: mockAPIService as! APIServiceProtocol)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        disposeBag = nil
    }
    
    func testFetchNews() {
        // Given
        let refreshAction = PublishSubject<Void>()
        let newsExpectation = expectation(description: "뉴스 업데이트") // XCTest expectation 객체 생성, 비동기 작업 완료 대기
        var fetchedNews: [News]? // 뉴스 데이터를 저장할 변수
        
        viewModel.transform(input: ListViewModel.Input(
            refreshAction: refreshAction,
            fetchMoreAction: PublishSubject<Void>(),
            saveReadNewsAction: PublishSubject<Int>()
        ))
        .news
        .subscribe(onNext: { news in
            print("Fetched news: \(news)")
            fetchedNews = news
            newsExpectation.fulfill() // 비동기 작업 완료됨
        }).disposed(by: disposeBag)
        
        // When
        refreshAction.onNext(())
        
        // Then
        waitForExpectations(timeout: 5, handler: nil) // newsExpectation 완료 최대 5초 대기
        XCTAssertNotNil(fetchedNews) // fetchedNews nil이 아닌지 확인
        XCTAssertTrue(fetchedNews!.count > 0) // fetchedNews 개수가 0보다 큰지 확인
    }
    
    
//    func testFetchMoreNews() {
//        // Given
//        let fetchMoreAction = PublishSubject<Void>()
//        let noMoreDataExpectation = expectation(description: "noMoreData should be true")
//        
//        viewModel.transform(input: ListViewModel.Input(
//            refreshAction: PublishSubject<Void>(),
//            fetchMoreAction: fetchMoreAction,
//            saveReadNewsAction: PublishSubject<Int>()
//        ))
//        .noMoreData
//        .subscribe(onNext: { noMoreData in
//            if noMoreData {
//                noMoreDataExpectation.fulfill()
//            }
//        }).disposed(by: disposeBag)
//        
//        // When
//        fetchMoreAction.onNext(())
//        
//        // Then
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    func testSaveNews() {
//        // Given
//        let saveReadNewsAction = PublishSubject<Int>()
//        let moveNewsExpectation = expectation(description: "moveNews should be called")
//        var movedNewsURL: String?
//        
//        viewModel.transform(input: ListViewModel.Input(
//            refreshAction: PublishSubject<Void>(),
//            fetchMoreAction: PublishSubject<Void>(),
//            saveReadNewsAction: saveReadNewsAction
//        ))
//        .moveNews
//        .subscribe(onNext: { url in
//            movedNewsURL = url
//            moveNewsExpectation.fulfill()
//        }).disposed(by: disposeBag)
//        
//        // When
//        saveReadNewsAction.onNext(0) // Assuming index 0 is valid
//        
//        // Then
//        waitForExpectations(timeout: 5, handler: nil)
//        XCTAssertNotNil(movedNewsURL)
//    }
//    
    
    
}
