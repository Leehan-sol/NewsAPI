//
//  NewsAPITests.swift
//  NewsAPITests
//
//  Created by hansol on 2024/08/03.
//

import XCTest
import RxSwift
@testable import NewsAPI

final class ListViewModelTests: XCTestCase {
    private var mockAPIService: MockAPIService!
    private var viewModel: ListViewModel!
    private var disposeBag: DisposeBag!
    
    private var refreshAction: PublishSubject<Void>!
    private var fetchMoreAction: PublishSubject<Void>!
    private var saveReadNewsAction: PublishSubject<Int>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = ListViewModel(apiService: mockAPIService)
        disposeBag = DisposeBag()
        refreshAction = PublishSubject<Void>()
        fetchMoreAction = PublishSubject<Void>()
        saveReadNewsAction = PublishSubject<Int>()
    }
    
    override func tearDown() {
        super.tearDown()
        mockAPIService = nil
        viewModel = nil
        disposeBag = nil
        refreshAction = nil
        fetchMoreAction = nil
        saveReadNewsAction = nil
    }
    
    
    func testFetchNews() {
        // Given
        // XCTest expectation 객체 생성, 비동기 작업 완료 대기
        let newsExpectation = expectation(description: "뉴스 업데이트 확인")
        var fetchedNews: [News]? // 뉴스 데이터를 저장할 변수
        var isExpectationFulfilled = false
        
        let input = buildInput(
            refresh: refreshAction,
            fetchMore: fetchMoreAction,
            saveReadNews: saveReadNewsAction
        )
        
        viewModel.transform(input: input)
            .news
            .subscribe(onNext: { news in
                if !isExpectationFulfilled {
                    isExpectationFulfilled = true
                    fetchedNews = news
                    newsExpectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        // When
        refreshAction.onNext(())
        
        // Then
        waitForExpectations(timeout: 5, handler: nil) // newsExpectation 완료 최대 5초 대기
        XCTAssertNotNil(fetchedNews) // fetchedNews nil이 아닌지 확인
        XCTAssertTrue(fetchedNews!.count > 0) // fetchedNews 개수가 0보다 큰지 확인
    }
    
    func testFetchMoreNews() {
        // Given
        let noMoreDataExpectation = expectation(description: "noMoreData 호출 확인")
        
        let input = buildInput(
            refresh: refreshAction,
            fetchMore: fetchMoreAction,
            saveReadNews: saveReadNewsAction
        )
        
        viewModel.transform(input: input)
            .noMoreData
            .subscribe(onNext: { noMoreData in
                if noMoreData {
                    print("noMoreData", noMoreData)
                    noMoreDataExpectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        // When
        fetchMoreAction.onNext(())
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSaveNews() {
        // Given
        let moveNewsExpectation = expectation(description: "이동할 URL 확인")
        var movedNewsURL: String?
        
        let input = buildInput(
            refresh: refreshAction,
            fetchMore: fetchMoreAction,
            saveReadNews: saveReadNewsAction
        )
        
        viewModel.transform(input: input)
            .moveNews
            .subscribe(onNext: { url in
                movedNewsURL = url
                moveNewsExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        // When
        saveReadNewsAction.onNext(0)
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(movedNewsURL)
    }
    
    private func buildInput(refresh: PublishSubject<Void>,
                            fetchMore: PublishSubject<Void>,
                            saveReadNews: PublishSubject<Int>) -> ListViewModel.Input {
        
        return ListViewModel.Input(refreshAction: refresh,
                                   fetchMoreAction: fetchMore,
                                   saveReadNewsAction: saveReadNews)
    }
    
    
    
}
