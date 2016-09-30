//
//  AlertControllerItem.h
//  LazyNotes
//
//  Created by yaosixu on 2016/9/30.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertControllerItem : NSObject

@property(nonatomic,readonly,copy) NSString *itemName;
@property(nonatomic,readonly,strong) void (^myBlock)();
-(instancetype)init:(NSString *)itemName myBlock:(void (^)())block;

@end
