//
//  AlertControllerItem.m
//  LazyNotes
//
//  Created by yaosixu on 2016/9/30.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import "AlertControllerItem.h"

@implementation AlertControllerItem

-(instancetype)init:(NSString *)itemName myBlock:(void (^)())block {
    if (self = [super init]) {
        _itemName = itemName;
        _myBlock = block;
    }
    return self;
}

@end
