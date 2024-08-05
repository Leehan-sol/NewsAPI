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
