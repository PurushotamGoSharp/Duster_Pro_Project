//
//  SuccessViewController.h
//  Testkit
//
//  Created by Martin Prabhu on 10/20/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessViewController : UIViewController
{
    NSDictionary *dict;
    
}
@property(nonatomic,retain)NSMutableDictionary *jsondict;

@property(nonatomic,retain)IBOutlet UIScrollView *scroll;


@end
