//
//  FeedCell.h
//  iOSTest
//
//  Created by Abir Chatterjee on 13/06/18.
//  Copyright © 2018 Abir Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewAligned.h"

@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIImageViewAligned *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHtConst;
@end
