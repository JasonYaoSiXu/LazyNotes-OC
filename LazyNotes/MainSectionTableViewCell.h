//
//  MainSectionTableViewCell.h
//  LazyNotes
//
//  Created by yaosixu on 2016/9/28.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainSectionTableViewCell : UITableViewCell

// label of context
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
// label of time
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
