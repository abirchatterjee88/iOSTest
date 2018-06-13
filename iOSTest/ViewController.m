//
//  ViewController.m
//  iOSTest
//
//  Created by Abir Chatterjee on 12/06/18.
//  Copyright © 2018 Abir Chatterjee. All rights reserved.
//

#import "ViewController.h"
#import "APIConnection.h"
#import "FeedCell.h"
#import "UIImageView+WebCache.h"
#import <ImageIO/ImageIO.h>
@interface ViewController ()
@property (strong, nonatomic) FeedCell *feedCell;

@end

@implementation ViewController{
    APIConnection *connection;
    NSArray *arrayList;
    UIRefreshControl*refreshControl;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    connection = [[APIConnection alloc] init];
    arrayList = [[NSArray alloc] init];
    feedTbl.estimatedRowHeight = 100.0f;
    feedTbl.rowHeight = UITableViewAutomaticDimension;
    [connection setDelegate:(id)self];
    [connection startAPICallWithPostString:nil withUrlMethodName:@"s/2iodh4vg0eortkl/facts.json"];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor clearColor];
    refreshControl.tintColor = [UIColor brownColor];
    [refreshControl addTarget:self action:@selector(reloadPageData) forControlEvents:UIControlEventValueChanged];
    [feedTbl addSubview:refreshControl];
    
    [feedTbl setHidden:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)reloadPageData{
    [connection setDelegate:(id)self];
    [connection startAPICallWithPostString:nil withUrlMethodName:@"s/2iodh4vg0eortkl/facts.json"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId =@"feedCell";
    
    FeedCell *cell = [feedTbl dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell.titleLbl setText:[self checkNull:[[arrayList objectAtIndex:indexPath.row]valueForKey:@"title"]]];
    [cell.descLbl setText:[self checkNull:[[arrayList objectAtIndex:indexPath.row]valueForKey:@"description"]]];
    //ImageSize Calculation
    if ([[self checkNull:[[arrayList objectAtIndex:indexPath.row]valueForKey:@"imageHref"]] length] == 0) {
        cell.imgHtConst.constant = 0;
    }else{
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[self checkNull:[[arrayList objectAtIndex:indexPath.row]valueForKey:@"imageHref"]]] placeholderImage:[UIImage imageNamed:@"default-image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        }];
        cell.imgHtConst.constant = 220;
    }
    [cell.imgView layoutIfNeeded];
    return cell;
}


#pragma mark - APIConnection Delegates
-(void)webserviceCallFailOrError : (NSString *)errorMessage{
    
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data{
    NSLog(@"Response:==%@",data);
    arrayList = [[data valueForKey:@"rows"] mutableCopy];
    [feedTitle setText:[self checkNull:[data valueForKey:@"title"]]];
    [refreshControl endRefreshing];
    [feedTbl setHidden:NO];
    [feedTbl reloadData];
    
    [UIView animateWithDuration:0.2 animations:^{
        feedTbl.alpha = 0.0f;
        feedTbl.alpha = 1.0f;
    }];
}


#pragma mark - Chech Null
-(NSString *)checkNull:(NSString*)type{
    //[type  isEqual: @"<null>"]
    if (type == nil || type == (id)[NSNull null] ||[[NSString stringWithFormat:@"%@",type] length] == 0 || [[[NSString stringWithFormat:@"%@",type] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return @"";
    }
    else{
        return type;
    }
}

@end
