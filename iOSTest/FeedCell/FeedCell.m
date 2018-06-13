//
//  FeedCell.m
//  iOSTest
//
//  Created by Abir Chatterjee on 13/06/18.
//  Copyright © 2018 Abir Chatterjee. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.alignLeft = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
