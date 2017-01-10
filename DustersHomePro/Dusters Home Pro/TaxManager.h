//
//  TaxManager.h
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 16/10/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxManager : NSObject

+ (TaxManager *)sharedInstance;
- (void)currentTax:(void(^)(BOOL success, CGFloat tax))completoinHandler;
- (NSInteger)minSecsBeforeBooking;

@end
