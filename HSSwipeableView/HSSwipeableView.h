//
//  HSSwipeableView.h
//
//  Created by LeeRowoon on 2016. 1. 11..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  SwipeableView를 Swipe해서 넘겼을때 상태
 */
typedef NS_ENUM(NSInteger, HSSwipeableViewSwiped) {
    /**
     *  왼쪽으로 넘겼을때
     */
    HSSwipeableViewSwipedLeft,
    /**
     *  오른쪽으로 넘겼을때
     */
    HSSwipeableViewSwipedRight
};

/**
 *  Swipe해서 넘겼을때 왼쪽, 오른쪽으로 넘겼는지 구분해서 처리할 Block
 *
 *  @param direction Swipe해서 넘긴 방향
 */
typedef void(^SwipedBlock)(HSSwipeableViewSwiped direction);

@interface HSSwipeableView : UIView

/**
 *  SWipeableView안에 들어갈 내용뷰<br>
 *  여기에 넣고 싶은 View를 넣으면 된다.
 */
@property (nonatomic, strong) UIView *contentView;

/**
 *  SwipeableView를 Swipe해서 넘겼을때 상태에 따라 처리할 Block을 설정
 */
- (void)setSwipedBlock:(SwipedBlock)block;

@end