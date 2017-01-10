//
//  VMEnvironment.m
//  Dusters Home Pro
//
//  Created by Vmoksha on 01/04/16.
//  Copyright © 2016 shruthib. All rights reserved.
//

#import "VMEnvironment.h"


@implementation VMEnvironment

+(instancetype)environment {
    static VMEnvironment *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VMEnvironment alloc] init];
    });
    return instance; }

-(instancetype)init
{ self = [super init];
    if (self != nil) {
        //examples. Use proper values here.
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"environment" ofType:@"plist"]];
        _environmentName = plist[@"environment"];
        _buildCommit     = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        _baseUrl       = plist[@"baseUrl"];
    }
    return self;
}




@end
