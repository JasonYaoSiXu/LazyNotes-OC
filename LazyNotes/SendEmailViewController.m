//
//  SendEmailViewController.m
//  LazyNotes
//
//  Created by yaosixu on 2016/9/29.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import "SendEmailViewController.h"

@interface SendEmailViewController ()

@end

@implementation SendEmailViewController {
    //邮件初始内容
    NSString *_emailContext;
    //邮件主题
    UITextField *_emailTheme;
    //邮件收件人的地址
    UITextField *_acceptEmailAddressTextField;
    //邮件内容
    UITextView *_emailTextView;
    //发送按钮
    UIButton *_sendButton;
}

-(instancetype)init:(NSString *)emailContext {
    if (self  = [super init]) {
        _emailContext = emailContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.title = @"发送邮件";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UILabel *titles = [[UILabel alloc] init];
    titles.text = @"发送邮件";
    [titles sizeToFit];
    titles.backgroundColor = [UIColor clearColor];
    titles.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titles;
    [self initAddSubviews];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化并且添加子视图
-(void)initAddSubviews {
    _emailTheme = [[UITextField alloc] initWithFrame:CGRectMake(10, 74, [UIScreen mainScreen].bounds.size.width - 20, TEXTFIELD_HEIGHT)];
    _emailTheme.backgroundColor = [UIColor whiteColor];
    _emailTheme.text = @"这是一封来自懒人笔记的邮件";
    [self.view addSubview:_emailTheme];
    
    _acceptEmailAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, _emailTheme.frame.origin.y + _emailTheme.bounds.size.height + 10, [UIScreen mainScreen].bounds.size.width - 20, TEXTFIELD_HEIGHT)];
    _acceptEmailAddressTextField.backgroundColor = [UIColor whiteColor];
    _acceptEmailAddressTextField.placeholder = @"请填写收件人地址";
    [self.view addSubview:_acceptEmailAddressTextField];
    
    CGFloat offSetY = _acceptEmailAddressTextField.frame.origin.y + _acceptEmailAddressTextField.bounds.size.height;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - offSetY;
    _emailTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, offSetY + 10, [UIScreen mainScreen].bounds.size.width - 20, height - 100)];
    _emailTextView.backgroundColor = [UIColor whiteColor];
    _emailTextView.text = _emailContext;
    [self.view addSubview:_emailTextView];
    
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(100, _emailTextView.frame.origin.y + _emailTextView.bounds.size.height + 20, 100, 30)];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _sendButton.backgroundColor = [UIColor whiteColor];
    [_sendButton addTarget:self action:@selector(tapSendButtonAciont) forControlEvents:UIControlEventTouchUpInside];
    CGPoint sendButtonCenter = _sendButton.center;
    sendButtonCenter.x = self.view.center.x;
    _sendButton.center = sendButtonCenter;
    [self.view addSubview:_sendButton];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

//tap sendButton
-(void)tapSendButtonAciont {
    NSLog(@"%s",__FUNCTION__);
    if ([_emailTextView.text isEqualToString:@""] || [_emailTheme.text isEqualToString:@""] || [_acceptEmailAddressTextField.text isEqualToString:@""]) {
        [self alertView:@"请填写必要的信息" detailMessage:@"邮件主题、收件人地址、邮件内容不能为空"];
        return;
    }
}

//tap rightButton
-(void)tapRightButton {
    NSLog(@"%s",__FUNCTION__);
    [_emailTheme resignFirstResponder];
    [_acceptEmailAddressTextField resignFirstResponder];
    [_emailTextView resignFirstResponder];
}

//alterView
-(void)alertView:(NSString *)title detailMessage:(NSString *)message {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:alertAction];
    [self presentViewController:alertView animated:YES completion:nil];
}

//send email to accept
-(void)sendEmail {
    
}

@end
