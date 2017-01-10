//
//  BookedJobModel.h
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 02/11/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookedJobModel : NSObject

@property (assign, nonatomic) NSInteger jobID;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *orderCode;
@property (strong, nonatomic) NSString *categoryCode;
@property (strong, nonatomic) NSString *subCategoryCode;
@property (strong, nonatomic) NSString *serviceTypeCode;
@property (strong, nonatomic) NSString *optionCode;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *subCategoryName;
@property (strong, nonatomic) NSString *serviceTypeName;
@property (strong, nonatomic) NSString *optionName;
//@property (assign, nonatomic) CGFloat estimatedPrice;
@property (assign, nonatomic) NSTimeInterval serviceDurationInMins;


@property (assign, nonatomic) CGFloat estPrice;
@property (assign, nonatomic) CGFloat hourlyRate;

- (NSString *)nameOfJob;

@end
