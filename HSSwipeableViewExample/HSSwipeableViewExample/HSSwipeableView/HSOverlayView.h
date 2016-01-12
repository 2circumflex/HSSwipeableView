//
//  HSOverlayView.h
//
//  Created by LeeRowoon on 2016. 1. 11..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  오버레이뷰 상태 ENUM
 */
typedef NS_ENUM(NSInteger, HSOverlayViewState) {
    /**
     *  왼쪽
     */
    HSOverlayViewStateLeft,
    /**
     *  오른쪽
     */
    HSOverlayViewStateRight
};

@interface HSOverlayView : UIView

/**
 *  오버레이뷰 상태<br>
 *  왼쪽인지 오른쪽인지 구분값
 */
@property (nonatomic) HSOverlayViewState state;

@end