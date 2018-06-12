//
//  AppDelegate.h
//  iOSTest
//
//  Created by Abir Chatterjee on 12/06/18.
//  Copyright © 2018 Abir Chatterjee. All rights reserved.
//
#import "APIConnection.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "Reachability.h"

@implementation APIConnection{
    NSMutableData *_responseData;
    int connectionFlag;
    UIViewController * controller;
}
@synthesize baseUrl;

#pragma mark Singleton Methods

+ (APIConnection *)sharedManager {
    static APIConnection *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        baseUrl = @"https://dl.dropboxusercontent.com/";
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return self;
}

-(BOOL)isNetworkAvailable{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
        return false;
    else
        return true;
}

- (UIViewController*) topMostController{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}
-(void)startAPICallWithPostString:(NSString *)postString withUrlMethodName:(NSString *)urlSuffix{
    if (![self isNetworkAvailable]) {
        UIAlertView *obj = [[UIAlertView alloc] initWithTitle:nil message:@"No Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [obj show];
        return;
    }
    
    NSString *query = [NSString stringWithFormat:@"%@%@",baseUrl,urlSuffix];
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",query]];
    NSLog(@"URL==%@",aUrl);
 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    if (postString.length > 0) {
        NSLog(@"postString==%@",postString);
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        [request setHTTPMethod:@"GET"];
    }
   
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.activityIndicator removeFromSuperview];
    [connection start];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError *error;
    [controller.view setUserInteractionEnabled:YES];
    // Print Rawdata
    
    NSString *encodingString = [[NSString alloc] initWithData:_responseData encoding:NSISOLatin1StringEncoding];
    NSData *rawData = [encodingString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingMutableContainers error:&error];
    
    if (!error) {
        //Do Your Stuff
        if (self.delegate) {
            [self.delegate WebServiceCallFinishWithData:dataDic];
        }
    } else {
        //fail delegate will come
        if (self.delegate) {
            [self.delegate webserviceCallFailOrError:@"Some Server Problem Encountered"];
        }
        return;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    if (self.delegate) {
        @try{
            [self.delegate webserviceCallFailOrError:@"Some Server Problem Encountered"];
        }@catch (NSException * e){
            
        }
        
    }
    
    //fail delegate will come
    
}


@end
