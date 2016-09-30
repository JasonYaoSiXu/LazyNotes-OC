//
//  MainSectionTableViewCell.m
//  LazyNotes
//
//  Created by yaosixu on 2016/9/28.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import "MainSectionTableViewCell.h"

@implementation MainSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _contextLabel.numberOfLines = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
