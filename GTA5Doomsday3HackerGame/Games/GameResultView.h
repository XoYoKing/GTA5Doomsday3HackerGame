//
//  GameResultView.h
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/4/3.
//  Copyright © 2019 Jam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameResultView : UIView

+ (instancetype)showGameResultViewWithSuccess:(BOOL)isSuccessful didFinishHandler:(void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END
