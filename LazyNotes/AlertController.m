//
//  AlertController.m
//  LazyNotes
//
//  Created by yaosixu on 2016/9/30.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import "AlertController.h"

@implementation AlertController

+(instancetype)shared {
    static AlertController* singal = nil;
    if (!singal) {
        singal = [[self alloc] initPrivate];
    }
    return singal;
}

-(instancetype)initPrivate {
    if (self = [super init]) {
        return self;
    }
    return self;
}

//-(void)showAlertHandledAciton:(NSArray <NSString *>*)nameArray detailAction:(NSArray <void (^ )()>*)actions targetViewController:(UIViewController *)targetVC {
//    
//    UIAlertController *alertController = [[UIAlertController alloc] init];
//    
//    if ([nameArray count] != [actions count]) {
//        return;
//    }
//    
//    for (NSInteger i = 0; i < [nameArray count]; i++) {
//        UIAlertActionStyle style = UIAlertActionStyleDefault;
//        if (i == [nameArray count] - 1) {
//            style = UIAlertActionStyleCancel;
//        }
//        
//        UIAlertAction *action = [UIAlertAction actionWithTitle:nameArray[i] style:style handler:^(UIAlertAction *action){
//            void (^ myBlock)() = actions[i];
//            myBlock();
//        }];
//        [alertController addAction:action];
//    }
//    [targetVC presentViewController:alertController animated:YES completion:nil];
//}

-(void)showAlertHandledAction:(NSArray <AlertControllerItem *>*)itemArray targetViewController:(UIViewController *)targetVC {
    UIAlertController *alertController = [[UIAlertController alloc] init];
    NSInteger index = 0;
    for (AlertControllerItem* item in itemArray) {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (index == [itemArray count] - 1) {
            style = UIAlertActionStyleCancel;
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:item.itemName style:style handler:^(UIAlertAction *action){
            item.myBlock();
        }];
        index += 1;
        [alertController addAction:action];
    }
    [targetVC presentViewController:alertController animated:YES completion:nil];
}


@end
