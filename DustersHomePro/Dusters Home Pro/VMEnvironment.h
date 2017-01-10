//
//  VMEnvironment.h
//  Dusters Home Pro
//
//  Created by Vmoksha on 01/04/16.
//  Copyright © 2016 shruthib. All rights reserved.
//

#import <Foundation/Foundation.h>

#define base_url [VMEnvironment environment].baseUrl

@interface VMEnvironment : NSObject


@property(nonatomic,strong)NSString *environmentName;
@property(nonatomic,strong)NSString *buildCommit;
@property(nonatomic,strong)NSString *baseUrl;

@property(strong,nonatomic)NSString *userCode;
@property(strong,nonatomic)NSString *regCode;
@property(strong,nonatomic)NSString *pasCode;
+(instancetype)environment;

@end
