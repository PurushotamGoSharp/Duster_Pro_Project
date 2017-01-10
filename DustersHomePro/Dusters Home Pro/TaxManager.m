//
//  TaxManager.m
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 16/10/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import "TaxManager.h"
#import "Postman.h"
#import "Constant.h"
#import "VMEnvironment.h"

@implementation TaxManager
{
    CGFloat currentTax;
    Postman *postman;
    BOOL callingAPI;
}

+ (TaxManager *)sharedInstance
{
    static dispatch_once_t once;
    static TaxManager *taxManager = nil;
    
    dispatch_once(&once, ^{
        taxManager = [[TaxManager alloc] init];
    });
    
    return taxManager;
}

- (instancetype)init
{
    self = [super init];
    currentTax = [[NSUserDefaults standardUserDefaults] floatForKey:kCURRENT_TAX_KEY];
    postman = [[Postman alloc] init];
    
    return self;
}

- (void)currentTax:(void(^)(BOOL success, CGFloat tax))completoinHandler
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"configuration_FLAG"])
    {
        if (!callingAPI)
        {
            [self callTaxAPI:completoinHandler];
        }
    }else
    {
        if (currentTax == 0.0)
        {
            [self callTaxAPI:completoinHandler];
        }else
        {
            completoinHandler(true, currentTax);
        }
    }
}

- (void)callTaxAPI:(void(^)(BOOL success, CGFloat tax))completoinHandler
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",base_url, kGET_CONFIG_URL];
    callingAPI = YES;
    [postman get:urlString withParameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             callingAPI = NO;
             NSDictionary *dict = responseObject;

             if ([dict[@"Success"] boolValue])
             {
                 for (NSDictionary *aDict in dict[@"ViewModels"])
                 {
                     if ([aDict[@"EntityCode"] isEqualToString:@"TAX01"])
                     {
                         currentTax = [aDict[@"Value"] floatValue];

                         [[NSUserDefaults standardUserDefaults] setFloat:currentTax forKey:kCURRENT_TAX_KEY];

                         [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"configuration_FLAG"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         completoinHandler(true, currentTax);

                     }else if ([aDict[@"EntityCode"] isEqualToString:@"CONFIG"])
                     {
                         NSInteger beforeTimeInSecs = [aDict[@"Value"] integerValue] * 60;;
                         [[NSUserDefaults standardUserDefaults] setInteger:beforeTimeInSecs forKey:kMIN_SEC_BEFORE_BOOKING_KEY];
                     }
                 }

             }else
             {
                 completoinHandler(false, currentTax);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             callingAPI = NO;
             completoinHandler(false, currentTax);
         }];
}

- (NSInteger)minSecsBeforeBooking
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kMIN_SEC_BEFORE_BOOKING_KEY];
}

@end
