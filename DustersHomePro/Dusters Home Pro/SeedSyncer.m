//
//  SeedSyncer.m
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 19/10/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import "SeedSyncer.h"
#import "Postman.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "DBManager.h"
#import "VMEnvironment.h"

@interface SeedSyncer () <DBManagerDelegate>

@end

@implementation SeedSyncer
{
    Postman *postman;
    NSString *urlString;
    NSUserDefaults *userDefault;
    DBManager *dbManager;
}

+ (SeedSyncer *)sharedSyncer
{
    static dispatch_once_t token;
    static SeedSyncer *syncer = nil;
    
    dispatch_once(&token, ^{
        syncer = [[SeedSyncer alloc] init];
    });
    
    return syncer;
}

- (instancetype)init
{
    self = [super init];
    
    postman = [[Postman alloc] init];
    urlString = [NSString stringWithFormat:@"%@%@", base_url, kGET_SEED_URL];
    userDefault = [NSUserDefaults standardUserDefaults];
    dbManager = [[DBManager alloc] initWithFileName:@"API_Resp.db"];
    dbManager.delegate = self;
    return self;
}

- (void)callSeedAPI:(void (^)(BOOL success))completionHandler
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:NO];
    [postman get:urlString withParameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([self parseAndSave:responseObject])
             {
                 completionHandler(true);
             }else
             {
                 completionHandler(false);
             }
             [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completionHandler(false);
             [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
         }];
}

- (BOOL)parseAndSave:(id)response
{
    NSDictionary *dict = response;
    NSArray *seedArray = dict[@"seedmaster"];
    if (seedArray)
    {
        for (NSDictionary *seed in seedArray)
        {
            [self compareAndSave:seed];
        }
        
        return YES;
        
    }else
    {
        return NO;
    }
}

- (void)compareAndSave:(NSDictionary *)dict
{
    NSInteger localValue = [userDefault integerForKey:[NSString stringWithFormat:@"%@_VALUE", dict[@"Name"]]];
    NSInteger newValue = [dict[@"Value"] integerValue];
    if (localValue < newValue)
    {
        [userDefault setInteger:newValue forKey:[NSString stringWithFormat:@"%@_VALUE", dict[@"Name"]]];
        NSString *statusKey = [NSString stringWithFormat:@"%@_FLAG", dict[@"Name"]];
        [userDefault setBool:true forKey:statusKey];
        
        NSLog(@"Setting for flag %@", statusKey);
    }
}


- (void)saveResponse:(NSString *)responseString forIdentity:(NSString *)identity
{
    NSString *createQuery = @"create table if not exists API_TABLE (API text PRIMARY KEY, data text)";
    [dbManager createTableForQuery:createQuery];
    
    NSMutableString *mutResponseString = [responseString mutableCopy];
    NSRange rangeofString;
    rangeofString.location = 0;
    rangeofString.length = mutResponseString.length;
    [mutResponseString replaceOccurrencesOfString:@"'" withString:@"''" options:(NSCaseInsensitiveSearch) range:rangeofString];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  API_TABLE (API,data) values ('%@', '%@')", identity,mutResponseString];
    [dbManager saveDataToDBForQuery:insertSQL];
}

- (void)getResponseFor:(NSString *)identity completionHandler:(void (^)(BOOL success, id response))completionHandler
{
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM API_TABLE WHERE API = '%@'", identity];
    
    [dbManager getDataForQuery:queryString withCompletionHandler:^(BOOL success, sqlite3_stmt *statment) {
        if (success)
        {
            if (sqlite3_step(statment) == SQLITE_ROW)
            {
                NSString *string = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 1)];
                NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                id resopnse = [NSJSONSerialization JSONObjectWithData:data
                                                              options:kNilOptions
                                                                error:nil];
                completionHandler(YES, resopnse);
            }
        }else
        {
            completionHandler(NO, nil);
        }

    }];
}

- (void)DBManager:(DBManager *)manager gotSqliteStatment:(sqlite3_stmt *)statment
{
    
}

@end
