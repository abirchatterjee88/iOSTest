//
//  AppDelegate.h
//  iOSTest
//
//  Created by Abir Chatterjee on 12/06/18.
//  Copyright © 2018 Abir Chatterjee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol APIConnectionDelegate <NSObject>
@required
-(void)webserviceCallFailOrError : (NSString *)errorMessage;
-(void)WebServiceCallFinishWithData : (NSDictionary *)data;

@optional

@end

@interface APIConnection : NSObject<NSURLConnectionDelegate>{
    NSString *baseUrl;
}
@property (nonatomic, retain) NSString *baseUrl;
@property (nonatomic,strong) id <APIConnectionDelegate> delegate;

+ (id)sharedManager;
//- (void)webServiceCallWithPostString : (NSString *)postString urlSufix :(NSString *)urlSuffix;
-(void)startAPICallWithPostString : (NSString *)postString withUrlMethodName :(NSString *)urlSuffix;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;

@end
