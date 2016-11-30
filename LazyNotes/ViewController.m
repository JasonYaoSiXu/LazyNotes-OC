//
//  ViewController.m
//  LazyNotes
//
//  Created by yaosixu on 2016/9/28.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    UITableView *myTableView;
    NSString *cellIdentifier;
    OpeartorSqlite *sqlite;
    NSMutableArray *cellContentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cellIdentifier = @"MainSectionTableViewCell";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 200, 50)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.image = [self makeGenerateBar:@"1234567890" width:200 height:50];
    imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    [self.view addSubview:imageView];
    
    UIImageView *qdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 400, 200, 200)];
    qdImageView.image = [self makeQDBar:@"12344567890" width:200 height:200];
    [self.view addSubview:qdImageView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.title = @"懒人笔记";
//    //add title and subviews for navigationBar
//    [self addTitleSubviews];
//    //初始化并增加tableView
//    [self initAddTabelView];
//    // Do any additional setup after loading the view, typically from a nib.
}

//生成条形码
-(UIImage *)makeGenerateBar:(NSString *)code width:(CGFloat)width  height:(CGFloat)height {
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:NO];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    
    barcodeImage = [filter outputImage];
    CGFloat scaleX = width / barcodeImage.extent.size.width;
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *tempImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:tempImage];
}

//生成二维码
-(UIImage *)makeQDBar:(NSString *)code width:(CGFloat)width  height:(CGFloat)height {
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:NO];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    
    barcodeImage = [filter outputImage];
    CGFloat scaleX = width / barcodeImage.extent.size.width;
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *tempImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:tempImage];
}




-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    sqlite = [OpeartorSqlite shared];
    cellContentArray = [[sqlite checkDataFromSqlite] mutableCopy];
    [myTableView reloadData];
    //设置导航栏背景色，以及添加按钮
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航栏背景色，以及添加按钮
-(void)initNavigationBar {
    //set status bar color is whiteColor
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // navigationBar's subViews's tintColor
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // navigationBar's backGroundColor
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    
} //initNavigationBar

//添加标题和子视图
-(void)addTitleSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"懒人笔记";
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"micro_small"] style:UIBarButtonItemStyleDone target:self action:@selector(tapLeftBarButtonAction)];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_add_tab"] style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBarButtonAction)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
} //addTitleSubviews

// 点击导航栏左侧的按钮
-(void)tapLeftBarButtonAction {
    NSLog(@"%s",__FUNCTION__);
} //tapLeftBarButtonAction

//点击导航栏右侧的按钮
-(void)tapRightBarButtonAction {
    NSLog(@"%s",__FUNCTION__);
//    [self.navigationController pushViewController:[ModifyContextViewController new] animated:YES];
    [self.navigationController pushViewController:[[ModifyContextViewController alloc] init] animated:YES];
} //tapRightBarButtonAction

//增加并初始化tableView
-(void)initAddTabelView {
    myTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    myTableView.dataSource = self;
    myTableView.delegate =  self;
    
    myTableView.estimatedRowHeight = 44;
    myTableView.rowHeight = UITableViewAutomaticDimension;
    myTableView.tableFooterView = [UIView new];
    
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [myTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:myTableView];
    
} //initAddTabelView


//MARK: -- UITableViewDelagate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellContentArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    cell.contextLabel.text = cellContentArray[indexPath.row];
//    cell.timeLabel.text = [self stringFromDate:[NSDate date]];
    NSDictionary *dict = cellContentArray[indexPath.row];
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *filePath = [path stringByAppendingPathComponent:dict[MESSAGE_PATH]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:@"/Users/yaosixu/Library/Developer/CoreSimulator/Devices/467ED823-BB12-448C-8690-EACECC2CF7B6/data/Containers/Data/Application/D04B85AE-371F-44A8-AF80-4527FB53E710/Documents/"]) {
        NSLog(@"YES");
    } else {
        NSLog(@"no");
    }
    
    cell.contextLabel.text = [NSString stringWithContentsOfFile:dict[MESSAGE_PATH] encoding:NSUTF8StringEncoding error:nil];
    cell.timeLabel.text = dict[TIMES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteData:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"you tap the %lu row",indexPath.row);
    NSDictionary *dict = cellContentArray[indexPath.row];
    [self.navigationController pushViewController:[[ModifyContextViewController alloc] initWithFilePathCreateTimes:dict[MESSAGE_PATH] fileCreatesTime:dict[TIMES]] animated:YES];
    //    [self.navigationController pushViewController:[ModifyContextViewController new] animated:YES];
    
} //end UITableViewDelegate UITableViewDataSource

//从tableView删除指定的行，并从数据源中删除指定的数据
-(void)deleteData:(NSIndexPath *)indexPath {
    NSDictionary *dict = cellContentArray[indexPath.row];
    [sqlite deleteDateFromSqlite:dict[TIMES]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dict[MESSAGE_PATH]]) {
//        if ([fileManager isDeletableFileAtPath:dict[MESSAGE_PATH]]) {
//            NSLog(@"删除成功!");
//        } else {
//            NSLog(@"删除失败!");
//        }
        if ([fileManager removeItemAtPath:dict[MESSAGE_PATH] error:nil]) {
            NSLog(@"删除成功!");
        } else {
            NSLog(@"删除失败!");
        }
    }
    [cellContentArray removeObjectAtIndex:indexPath.row];
    NSArray<NSIndexPath *> *array = [[NSArray alloc] initWithObjects:indexPath, nil];
    [myTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
} //deleteData

//将时间转位指定格式的字符串
-(NSString *)stringFromDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [formatter stringFromDate:date];
} //stringFromDate

@end
