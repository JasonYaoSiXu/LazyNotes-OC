//
//  AlertController.h
//  LazyNotes
//
//  Created by yaosixu on 2016/9/30.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertControllerItem.h"

@interface AlertController : NSObject

+(instancetype)shared;
//-(void)showAlertHandledAciton:(NSArray <NSString *>*)nameArray detailAction:(NSArray <void (^ )()>*)actions targetViewController:(UIViewController *)targetVC;
-(void)showAlertHandledAction:(NSArray <AlertControllerItem *>*)itemArray targetViewController:(UIViewController *)targetVC;

@end
