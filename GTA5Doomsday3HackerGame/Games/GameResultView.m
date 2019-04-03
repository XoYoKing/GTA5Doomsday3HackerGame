//
//  GameResultView.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/4/3.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "GameResultView.h"

@interface GameResultView()

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation GameResultView

+ (instancetype)showGameResultViewWithSuccess:(BOOL)isSuccessful didFinishHandler:(void (^)(void))handler {
    GameResultView *view = [[[UINib nibWithNibName:@"GameResultView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    [view showSuccess:isSuccessful didFinishHandler:handler];
    return view;
}

- (void)showSuccess:(BOOL)isSuccessful didFinishHandler:(void (^)(void))handler {
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.frame = UIScreen.mainScreen.bounds;
    
    self.resultLabel.text = isSuccessful ? @"成功" : @"失败";
    self.backgroundColor = isSuccessful ?
                                [UIColor colorWithRed:0 green:0.4 blue:0 alpha:1]
                                : [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1];
    
    NSTimeInterval duration = 3.0;
    int totalRound = 20;
    NSTimeInterval relativeDuration = duration / totalRound;
    [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        for (int i = 0; i < totalRound; i ++) {
            [UIView addKeyframeWithRelativeStartTime:relativeDuration * i  relativeDuration:relativeDuration animations:^{
                self.resultLabel.alpha = (i % 2) == 0 ? 0 : 1;
            }];
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (handler) {
            handler();
        }
    }];
}

@end
