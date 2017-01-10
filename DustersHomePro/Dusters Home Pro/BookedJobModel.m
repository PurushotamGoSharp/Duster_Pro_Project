//
//  BookedJobModel.m
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 02/11/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import "BookedJobModel.h"

@implementation BookedJobModel

- (NSString *)nameOfJob
{
    return [NSString stringWithFormat:@"%@ (%@)", self.subCategoryName, self.serviceTypeName];
}


@end
