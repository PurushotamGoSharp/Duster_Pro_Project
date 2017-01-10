//
//  SeedSyncer.h
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 19/10/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeedSyncer : NSObject 

+ (SeedSyncer *)sharedSyncer;
- (void)callSeedAPI:(void (^)(BOOL success))completionHandler;
- (void)saveResponse:(NSString *)responseString forIdentity:(NSString *)identity;
- (void)getResponseFor:(NSString *)identity completionHandler:(void (^)(BOOL success, id response))completionHandler;

@end
