//
//  MRMSiOS.h
//  MRMSiOS
//
//  Copyright (c) 2014 RMSID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import "MRMSiOS.h"

@import AdSupport;

@interface MRMSiOS : NSObject {
    NSString *apiURL;
    NSString *deviceAPIURL;
}

- (id)init;
- (id)initWithDemo:(bool)useDemo;
- (NSString *)createSession;
- (NSDictionary *)callAPIendpoint:(NSString *)endPoint withParameters:(NSDictionary *)params andMethod:(NSString *)method;
- (NSDictionary *)callDeviceAPIwithParameters:(NSDictionary *)params;


@end
