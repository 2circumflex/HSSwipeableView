//
//  HSOverlayView.m
//
//  Created by LeeRowoon on 2016. 1. 11..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import "HSOverlayView.h"

/**
 *  왼쪽 상태일때 이미지명
 */
static NSString * const kDefaultLeftStateImageName = @"thumb_down";

/**
 *  오른쪽 상태일때 이미지명
 */
static NSString * const kDefaultRightStateImageName = @"thumb_up";

@interface HSOverlayView()

/**
 *  오버레이뷰 가운데 표시될 이미지뷰
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 *  왼쪽 상태 이미지
 */
@property (nonatomic, strong) UIImage *leftStateImage;

/**
 *  오른쪽 상태 이미지
 */
@property (nonatomic ,strong) UIImage *rightStateImage;

@end

@implementation HSOverlayView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeView];
    }
    return self;
}

#pragma mark - UI

/**
 *  View 초기화<br>
 *  이미지뷰 사이즈는 100 * 100, 가운데
 */
- (void)initializeView {
    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.imageView.image = self.leftStateImage;
    self.imageView.center = self.center;
    [self addSubview:_imageView];
}

#pragma mark - Property

/**
 *  왼쪽 상태 이미지 리턴<br>
 *  leftSTateImage 프로퍼티 오버라이드
 */
- (UIImage *)leftStateImage {
    if (!_leftStateImage) {
        _leftStateImage = [UIImage imageNamed:kDefaultLeftStateImageName];
    }
    return _leftStateImage;
}

/**
 *  오른쪽 상태 이미지 리턴<br>
 *  rightStateImage 프로퍼티 오버라이드
 */
- (UIImage *)rightStateImage {
    if (!_rightStateImage) {
        _rightStateImage = [UIImage imageNamed:kDefaultRightStateImageName];
    }
    return _rightStateImage;
}

/**
 *  상태(왼쪽, 오른쪽) 설정<br>
 *  state 프로퍼티 오버라이드
 */
- (void)setState:(HSOverlayViewState)state {
    if (_state == state) {
        return;
    } else {
        _state = state;
    }
    
    if (_state == HSOverlayViewStateLeft) {
        _imageView.image = self.leftStateImage;
    } else {
        _imageView.image = self.rightStateImage;
    }
}

@end
