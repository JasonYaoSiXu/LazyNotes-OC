//
//  ModifyContextViewController.m
//  LazyNotes
//
//  Created by yaosixu on 2016/9/28.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

// wxAppid wxc5650f664872449d
// wxAppSecret  f8a4e89d36474845ce4f27c4dc715aff


#import "ModifyContextViewController.h"

typedef NS_ENUM(NSInteger, SharedType) {
    Session, //分享道会话
    Timeline //分享到朋友圈
};

@interface ModifyContextViewController ()

@end

@implementation ModifyContextViewController {
    UITextView *textView;
    UIButton *recordVoiceButton;
    NSString *_filePath;
    NSString *_fileCreatTimes;
}

-(instancetype)initWithFilePathCreateTimes:(NSString *)filePath fileCreatesTime:(NSString *)createTime {
    if (self = [super init]) {
        _filePath = filePath;
        _fileCreatTimes = createTime;
    }
    return self;
}

-(instancetype)init {
    if (self = [super init]) {
        _filePath = nil;
        _fileCreatTimes = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initIFlySpeechRecognizer];
    
    //add itemButtons to navigationBar
    [self addItemButtonsToNavigationBar];
    
    // initAddTextView
    [self initAddTextView];
    
    //initAddRecordVoiceButton
    [self initAddRecordVoiceButton];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// initAddTextView
-(void)initAddTextView {
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2 / 3)];
    textView.textColor = [UIColor blueColor];
    
    if (_filePath) {
        textView.text = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
    }
    
    [self.view addSubview:textView];
} //initAddTextView

//initAddRecordVoiceButton
-(void)initAddRecordVoiceButton {
    recordVoiceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, textView.bounds.size.height + 30, 100, 100)];
    
    CGPoint center = recordVoiceButton.center;
    center.x = self.view.center.x;
    recordVoiceButton.center = center;
    recordVoiceButton.backgroundColor = [UIColor blueColor];
    [recordVoiceButton setTitle:@"语音输入" forState:UIControlStateNormal];
    [recordVoiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recordVoiceButton.layer.cornerRadius = MIN(recordVoiceButton.bounds.size.height / 2, recordVoiceButton.bounds.size.width / 2);
    recordVoiceButton.layer.masksToBounds = YES;
    [recordVoiceButton addTarget:self action:@selector(tapRecordVoiceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordVoiceButton];
} //initAddRecordVoiceButton

//add itemButtons to navigationBar
-(void)addItemButtonsToNavigationBar {
    NSMutableArray <UIBarButtonItem *> * itemButtonArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *itemBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more_white"] style:UIBarButtonItemStyleDone target:self action:@selector(tapMoreButtonAction)];
    [itemButtonArray addObject:itemBarButton];

    itemBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(tapSaveButtonAction)];
    [itemButtonArray addObject:itemBarButton];
    
    self.navigationItem.rightBarButtonItems = itemButtonArray;
} //addItemButtonsToNavigationBar

//tap save button action
-(void)tapSaveButtonAction {
    NSLog(@"%s",__FUNCTION__);
    [self saveMessage];
} //tapSaveButtonAction

//tap more button action
-(void)tapMoreButtonAction {
    NSLog(@"%s",__FUNCTION__);
    [self showMoreAction];
} //tapMoreButtonAction

//tap recordVoiceButton
-(void)tapRecordVoiceButtonAction {
    NSLog(@"%s",__FUNCTION__);
    [_iflyRecognizerView start];
    NSLog(@"start listenning...");
    
} //tapRecordVoiceButtonAction


//MARK --IFlySpeechRecognizer
-(void)initIFlySpeechRecognizer {
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    
    [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iflyRecognizerView setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
}

-(void)onError:(IFlySpeechError *)error {

}

-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
    NSMutableString *string = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [string appendFormat:@"%@", key];
    }
    textView.text = string;
}


//显示更多操作
-(void)showMoreAction {
    [textView resignFirstResponder];
    __weak typeof(ModifyContextViewController *)Self = self;
    NSMutableArray<AlertControllerItem *> *itemArray = [[NSMutableArray alloc] init];
    AlertControllerItem *item = [[AlertControllerItem alloc] init:COPY myBlock:^(){
        [Self copyAlertAction];
    }];
    [itemArray addObject:item];
    
    item = [[AlertControllerItem alloc] init:SHARED myBlock:^(){
        [Self shardToWeChatAction];
    }];
    [itemArray addObject:item];
    
    item = [[AlertControllerItem alloc] init:SEND_EMAIL myBlock:^(){
        [Self sendEmailAlertAction];
    }];
    [itemArray addObject:item];
    
    item = [[AlertControllerItem alloc] init:CANCEL myBlock:^(){
        NSLog(@"取消");
    }];
    [itemArray addObject:item];
    
    [[AlertController shared] showAlertHandledAction:[itemArray copy] targetViewController:self];
}

//复制操作
-(void)copyAlertAction {
    NSLog(@"%s",__FUNCTION__);
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    pastBoard.string = textView.text;
}

//发送邮件
-(void)sendEmailAlertAction {
    NSLog(@"%s",__FUNCTION__);
    if ([MFMailComposeViewController canSendMail]) {
        NSLog(@"can send mail");
    } else {
        NSLog(@"can't send mail");
    }
    MFMailComposeViewController *emailVc = [[MFMailComposeViewController alloc] init];
    [emailVc setMessageBody:textView.text isHTML:NO];
    emailVc.mailComposeDelegate = self;
    [self presentViewController:emailVc animated:YES completion:nil];
}

//分享
-(void)shardToWeChatAction {
    NSLog(@"%s",__FUNCTION__);
    NSMutableArray *shardArray = [[NSMutableArray alloc] init];
    __weak typeof(ModifyContextViewController *)Self = self;
    AlertControllerItem *item = [[AlertControllerItem alloc] init:SHARED_TO_SESSION myBlock:^(){
        [Self sharedTypes:Session];
    }];
    [shardArray addObject:item];
    
    item = [[AlertControllerItem alloc] init:SHARED_TO_TIMELINE myBlock:^(){
        [Self sharedTypes:Timeline];
    }];
    [shardArray addObject:item];
    
    [[AlertController shared] showAlertHandledAction:[shardArray copy] targetViewController:self];
}

-(void)sharedTypes:(SharedType)sharType {
    if ([WXApi isWXAppInstalled]) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"懒人记录";
        message.description = @"记录点滴";
        [message setThumbImage:[UIImage imageNamed:@"ic_add_tab"]];
        
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = @"https://github.com";
        message.mediaObject = webpageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (sharType == Session) {
            req.scene = WXSceneSession;
        } else {
            req.scene = WXSceneTimeline;
        }
        [WXApi sendReq:req];
    } else {
        return;
    }
}


//MARK save message to disk
-(void)saveMessage {
    
    if ([textView.text isEqualToString:@""]) {
        NSLog(@"%s,没有内容不保存",__FUNCTION__);
        return;
    }
    
    if (_fileCreatTimes != nil && _filePath != nil) {
        if ([textView.text writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
            NSLog(@"更新文件成功!");
        } else {
            NSLog(@"更新文件失败!");
        }
        return;
    }
    
    NSDate *date = [NSDate date];
    NSString *times = [self stringFromDate:date];
    NSString *filename = [self fileName:times];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    _fileCreatTimes = times;
    _filePath = filePath;
    if ([textView.text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
        [[OpeartorSqlite shared] insertDataToSqlite:times messagePath:filePath];
    } else {
        NSLog(@"%s,存储失败",__FUNCTION__);
    }
}

-(NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
} //stringFromDate

-(NSString *)fileName:(NSString *)times {
    NSMutableString *filename = [times mutableCopy];
    return [filename stringByReplacingOccurrencesOfString:@" " withString:@""];
}


//MARK MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
