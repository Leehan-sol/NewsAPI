//
//  UIScrollView+React.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/22.
//

import UIKit
import RxSwift

extension Reactive where Base: UIScrollView {
    
    // 바닥 감지
    var bottomReached: Observable<Void> {
        return contentOffset
            .distinctUntilChanged()
            .map{ (offset : CGPoint) in
                let height = self.base.frame.size.height
                let contentYOffset = offset.y
                let distanceFromBottom = self.base.contentSize.height - contentYOffset
                return distanceFromBottom < height
            }
            .filter{ $0 == true }.map{ _ in }
    }
    
}

//
//extension Reactive where Base: UIScrollView {
//    var bottomReached: Observable<Void> {
//        return Observable.create { [weak base] observer in
//            guard let scrollView = base else { return Disposables.create() }
//            
//            let contentOffsetObserver = scrollView.rx.contentOffset
//               
//                .filter { [weak scrollView] offset in
//                    guard let scrollView = scrollView else { return false }
//                    let height = scrollView.frame.size.height
//                    let contentYOffset = offset.y
//                    let distanceFromBottom = scrollView.contentSize.height - contentYOffset
//                    return distanceFromBottom < height
//                }
//                .map { _ in }
//                .subscribe(observer)
//            
//            return Disposables.create(contentOffsetObserver)
//        }
//    }
//}
//
