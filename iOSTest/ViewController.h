//
//  ViewController.h
//  iOSTest
//
//  Created by Abir Chatterjee on 12/06/18.
//  Copyright © 2018 Abir Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>{
    IBOutlet UITableView *feedTbl;
    IBOutlet UILabel *feedTitle;
}


@end

