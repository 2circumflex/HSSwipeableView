//
//  ViewController.m
//  HSSwipeableViewExample
//
//  Created by LeeRowoon on 2016. 1. 11..
//  Copyright © 2016년 2circumflex. All rights reserved.
//

#import "ViewController.h"
#import "HSSwipeableView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[
                       @"거봉.jpg",
                       @"골드키위.jpg",
                       @"구아바.jpg",
                       @"귤.jpg",
                       @"단감.jpg",
                       @"대추.jpg",
                       @"딸기.jpg",
                       @"라임.jpg",
                       @"라즈베리.jpg",
                       @"레몬.jpg",
                       @"리치.jpg",
                       @"망고.jpg",
                       @"망고스틴.jpg",
                       @"매실.jpg",
                       @"멜론.jpg",
                       @"모과.jpg",
                       @"무화과.jpg",
                       @"바나나.jpg",
                       @"배.jpg",
                       @"복숭아.jpg",
                       @"블랙베리.jpg",
                       @"블루베리.jpg",
                       @"사과.jpg",
                       @"살구.jpg",
                       @"석류.jpg",
                       @"수박.jpg",
                       @"애플망고.jpg",
                       @"오디.jpg",
                       @"오렌지.jpg",
                       @"용과.jpg",
                       @"유자.jpg",
                       @"자두.jpg",
                       @"자몽.jpg",
                       @"참외.jpg",
                       @"천도복숭아.jpg",
                       @"청포도.jpg",
                       @"체리.jpg",
                       @"코코넛.jpg",
                       @"키위.jpg",
                       @"파인애플.jpg",
                       @"파파야.jpg",
                       @"포도.jpg",
                       @"홍시.jpg"
                       ];
    
    int startValue = (int) [array count] - 1;
    for (int i=startValue; i>=0; i--) {
        
        CGRect swipeViewFrame = CGRectMake(0, 0, 280, 280);
        HSSwipeableView *swipeView = [[HSSwipeableView alloc] initWithFrame:swipeViewFrame];
        swipeView.center = self.view.center;
        
        UIImage *image = [UIImage imageNamed:[array objectAtIndex:i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        // SwipeableView에 이미지뷰 추가
        swipeView.contentView = imageView;
        
        // 블럭 추가
        [swipeView setSwipedBlock:^(HSSwipeableViewSwiped direction) {
            NSString *labelString;
            switch (direction) {
                case HSSwipeableViewSwipedLeft: {
                    labelString = [NSString stringWithFormat:@"%d 번째 아이템 왼쪽으로 넘어감", i];
                    break;
                }
                case HSSwipeableViewSwipedRight: {
                    labelString = [NSString stringWithFormat:@"%d 번째 아이템 오른쪽으로 넘어감", i];
                    break;
                }
            }
            self.label.text = labelString;
        }];
        
        // 맨 마지막 뷰에만 쉐도우
        if (i == startValue) {
            swipeView.layer.shadowOffset = CGSizeMake(8, 8);
            swipeView.layer.shadowRadius = 5;
            swipeView.layer.shadowOpacity = 0.5f;
            swipeView.layer.shadowColor = [UIColor blackColor].CGColor;
        }
        
        // SwipeableView 추가
        [self.view addSubview:swipeView];
    }
    
}

@end
