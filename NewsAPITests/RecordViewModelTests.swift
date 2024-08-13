//
//  RecordViewModelTests.swift
//  NewsAPITests
//
//  Created by hansol on 2024/08/12.
//

import XCTest
import RxSwift
@testable import NewsAPI

final class RecordViewModelTests: XCTestCase {
    private var mockRealmService: MockRealmService!
    private var viewModel: RecordViewModel!
    private var disposeBag: DisposeBag!
    
    private var saveReadNewsAction: PublishSubject<Int>!
    private var deleteReadNewsAction: PublishSubject<Int>!
    
    override func setUp() {
        super.setUp()
        mockRealmService = MockRealmService()
        viewModel = RecordViewModel(realmService: mockRealmService)
        disposeBag = DisposeBag()
        saveReadNewsAction = PublishSubject<Int>()
        deleteReadNewsAction = PublishSubject<Int>()
    }
    
    override func tearDown() {
        super.tearDown()
        mockRealmService = nil
        viewModel = nil
        disposeBag = nil
        saveReadNewsAction = nil
        deleteReadNewsAction = nil
    }
    
    func testLoadNews() {
        // Given
        let loadNewsExpectation = expectation(description: "뉴스 로드 확인")
        var loadedNews: [News]?
        var isExpectationFulfilled = false
        
        let input = buildInput (
            saveReadNews: saveReadNewsAction,
            deleteReadNews: deleteReadNewsAction
        )
        
        viewModel.transform(input: input)
            .readNews
            .subscribe(onNext: { news in
                if !isExpectationFulfilled {
                    isExpectationFulfilled = true
                    loadedNews = news
                    loadNewsExpectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        // When
        viewModel.loadNews()
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(loadedNews)
        XCTAssertTrue(loadedNews?.count ?? 0 > 0)
    }
    
    func testSaveNews() {
        // Given
        let saveNewsExpectation = expectation(description: "뉴스 저장 확인")
        var movedNewsURL: String?
        
        let input = buildInput (
            saveReadNews: saveReadNewsAction,
            deleteReadNews: deleteReadNewsAction
        )
        
        viewModel.transform(input: input)
            .moveNews
            .subscribe(onNext: { url in
                movedNewsURL = url
                saveNewsExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        // When
        saveReadNewsAction.onNext(0)
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(movedNewsURL)
        XCTAssertEqual(mockRealmService.mockNews.count, 3)
    }
    
    func testDeleteNews() {
        // Given
        let deleteNewsExpectation = expectation(description: "뉴스 삭제 확인")
        
        let input = buildInput(
            saveReadNews: saveReadNewsAction,
            deleteReadNews: deleteReadNewsAction
        )
        
        viewModel.transform(input: input)
            .readNews
            .subscribe(onNext: { news in
                deleteNewsExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        // When
        deleteReadNewsAction.onNext(0)
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(mockRealmService.mockNews.count, 1)
    }
    
    
    private func buildInput(saveReadNews: PublishSubject<Int>,
                            deleteReadNews: PublishSubject<Int>) -> RecordViewModel.Input {
        
        return RecordViewModel.Input(saveReadNewsAction: saveReadNews,
                                     deleteReadNewsAction: deleteReadNews)
    }
    
    
}
