//
//  HSSwipeableView.m
//
//  Created by LeeRowoon on 2016. 1. 11..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

/**
 *  Degree to Radian
 *
 *  @param x degree
 *
 *  @return radian
 */
#define degreeToRadian(x)(x*M_PI/180.0)

/**
 *  Swipe해서 넘길때 기준 거리
 */
static const int DRAG_DISTANCE = 120;

#import "HSSwipeableView.h"
#import "HSOverlayView.h"

/**
 *  Swipe해서 SwipeableView가 이동한 방향에 대한 구조체
 */
typedef struct {
    CGFloat x;
    CGFloat y;
} PanGesturePoint;

/**
 *  PanGesturePoint 만들어주는 함수
 */
PanGesturePoint PanGesturePointMake(CGFloat x, CGFloat y) {
    PanGesturePoint panGesturePoint;
    panGesturePoint.x = x;
    panGesturePoint.y = y;
    return panGesturePoint;
}

@interface HSSwipeableView()

/**
 *  SwipeableView의 원래 Center 위치
 */
@property (nonatomic) CGPoint originalCenterPoint;

/**
 *  오버레이뷰 (이동시 위에 덮어서 이미지 보여줄 뷰)
 */
@property (nonatomic, strong) HSOverlayView *overlayView;

/**
 *  SwipeableView Swipe처리할 Gesture
 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

/**
 *  Swipe해서 넘어갔을때 처리할 Block
 */
@property (nonatomic, strong) SwipedBlock block;

@end

@implementation HSSwipeableView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (void)dealloc {
    [self removeGestureRecognizer:_panGestureRecognizer];
    self.contentView = nil;
    [self setSwipedBlock:NULL];
}

#pragma mark - UI

/**
 *  View 초기화
 */
- (void)initializeView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5.0f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0f;

    // GestureRecognizer
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragged:)];
    [self addGestureRecognizer:_panGestureRecognizer];
    
    // OverlayView
    _overlayView = [[HSOverlayView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _overlayView.alpha = 0;
    [self addSubview:_overlayView];
}

/**
 *  Swipe 끝나면(손땠을때) 처리
 */
- (void)swipeOver:(PanGesturePoint)panGesturePoint {
    if (panGesturePoint.x > DRAG_DISTANCE) {
        [self swipedToRight:panGesturePoint];
    } else if (panGesturePoint.x < -DRAG_DISTANCE) {
        [self swipedToLeft:panGesturePoint];
    } else {
        [self restoreToOriginalState];
    }
}

/**
 *  SwipeableView를 왼쪽으로 넘겼을때 처리
 */
- (void)swipedToLeft:(PanGesturePoint)panGesturePoint {
    [self swipeToDirection:HSSwipeableViewSwipedLeft point:panGesturePoint];
}

/**
 *  SwipeableView를 오른쪽으로 넘겼을때 처리
 */
- (void)swipedToRight:(PanGesturePoint)panGesturePoint {
    [self swipeToDirection:HSSwipeableViewSwipedRight point:panGesturePoint];
}

/**
 *  SwipeableView를 화면 밖으로 이동<br>
 *  왼쪽 또는 오른쪽으로 넘겼을때
 */
- (void)swipeToDirection:(HSSwipeableViewSwiped)direction point:(PanGesturePoint)panGesturePoint {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat centerX;
    if (direction == HSSwipeableViewSwipedLeft) {
        centerX = -(screenBounds.size.width * 1.5);
    } else {
        centerX = (screenBounds.size.width * 1.5);
    }
    
    CGPoint centerPoint = CGPointMake(centerX, (panGesturePoint.y * 2) + self.originalCenterPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = centerPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    if (self.block) {
        self.block(direction);
    }
}

/**
 *  SwipeableView를 원래 위치로 원상복귀<br>
 *  일정거리(DRAG_DISTANCE만큼) Swipe 하지 않았으때.
 */
- (void)restoreToOriginalState {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = self.originalCenterPoint;
                         self.transform = CGAffineTransformMakeRotation(0);
                         self.overlayView.alpha = 0;
                     }];
}

/**
 *  Swipe중일때 처리
 */
- (void)setMovement:(PanGesturePoint)panGesturePoint {
    // Center 위치 변경
    CGFloat centerX = self.originalCenterPoint.x + panGesturePoint.x/2;
    CGFloat centerY = self.originalCenterPoint.y + panGesturePoint.y/2;
    self.center = CGPointMake(centerX, centerY);
    
    // 설정한 각을 유지하기 위해서 1 또는 -1 까지만
    CGFloat strength = panGesturePoint.x / self.frame.size.width;
    CGFloat minStrength;
    if (strength > 0) {
        minStrength = MIN(strength, 1);
    } else if (strength < 0) {
        minStrength = MAX(strength, -1);
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(degreeToRadian(20) * minStrength);
    self.transform = transform;
    
    [self updateOverlayView:panGesturePoint];
}

/**
 *  오버레이뷰 상태 업데이트
 */
- (void)updateOverlayView:(PanGesturePoint)panGesturePoint {
    if (panGesturePoint.x > 0) {
        self.overlayView.state = HSOverlayViewStateRight;
    } if (panGesturePoint.x < 0) {
        self.overlayView.state = HSOverlayViewStateLeft;
    }
    CGFloat overlayStrength = MIN(fabs(panGesturePoint.x) / 100, 0.6);
    self.overlayView.alpha = overlayStrength;
}

#pragma mark - handle GestureRecognizer

/**
 *  PanGestureRecognizer 처리할 메서드
 */
- (void)handleDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // Began -> Changed -> Ended
    
    // 드래그 시작했을때
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        // 손땠을때 특정거리만큼 움직이지 않았으면 원위치 시켜야 되므로, 위치 옮기기전에 원래 Center 위치 저장
        self.originalCenterPoint = self.center;
        return;
    }
    
    // 뷰가 이동한 위치를 구한다
    CGFloat x = [gestureRecognizer translationInView:self].x;
    CGFloat y = [gestureRecognizer translationInView:self].y;
    PanGesturePoint panGesturePoint = PanGesturePointMake(x, y);
    
    // 드래그중
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
        [self setMovement:panGesturePoint];
        return;
    }
    
    // 손 땟을때
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        [self swipeOver:panGesturePoint];
        return;
    }
}

#pragma mark - Accessor

/**
 *  SwipeableView를 Swipe해서 넘겼을때 상태에 따라 처리할 Block을 설정
 */
- (void)setSwipedBlock:(SwipedBlock)block {
    self.block = block;
}

#pragma mark - Property

/**
 *  SWipeableView안에 들어갈 내용뷰<br>
 *  여기에 넣고 싶은 View를 넣으면 된다.
 */
- (void)setContentView:(UIView *)contentView {
    if (_contentView == contentView) {
        return;
    }
    
    [_contentView removeFromSuperview];
    _contentView = contentView;
    
    contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    contentView.layer.cornerRadius = 5.0f;
    [contentView setClipsToBounds:YES];
    
    [self insertSubview:contentView atIndex:0];
}

@end
