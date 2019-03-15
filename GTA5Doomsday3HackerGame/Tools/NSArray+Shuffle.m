//
//  NSArray+Shuffle.m
//  GTA5Doomsday3HackerGame
//
//  Created by dabby on 2019/3/15.
//  Copyright © 2019 Jam. All rights reserved.
//

#import "NSArray+Shuffle.h"

@implementation NSArray (Shuffle)

- (NSArray *)shuffledArray{
    NSMutableArray *shus = [NSMutableArray arrayWithArray:self];
    NSInteger count = shus.count;
    for (NSInteger i = 0; i < count; i++) { // how many rounds should be better ?
        if (i > 0) {
            NSInteger randomIndex = arc4random()%i;
            [shus exchangeObjectAtIndex:randomIndex withObjectAtIndex:i];
        }
    }
    return shus;
}

@end
