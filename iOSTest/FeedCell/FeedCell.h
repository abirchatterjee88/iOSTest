//
//  FeedCell.h
//  iOSTest
//
//  Created by Abir Chatterjee on 13/06/18.
//  Copyright © 2018 Abir Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *descLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@end
