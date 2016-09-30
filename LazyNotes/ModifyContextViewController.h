//
//  ModifyContextViewController.h
//  LazyNotes
//
//  Created by yaosixu on 2016/9/28.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyMSC.h"
#import "OpeartorSqlite.h"
#import "SendEmailViewController.h"
#import <MessageUI/MessageUI.h>
#import "WXApi.h"
#import "AlertControllerItem.h"
#import "AlertController.h"
#import "ConstValue.h"

@interface ModifyContextViewController : UIViewController<IFlyRecognizerViewDelegate,MFMailComposeViewControllerDelegate> {
//    IFlySpeechRecognizer *_iflyRecognizerView;
    IFlyRecognizerView *_iflyRecognizerView;
}

@property (readonly,nonatomic,copy) NSString *context;

-(instancetype)initWithFilePathCreateTimes:(NSString *)filePath fileCreatesTime:(NSString *)createTime;
-(instancetype)init;

@end
