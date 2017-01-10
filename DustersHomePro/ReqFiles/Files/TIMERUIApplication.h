//
//  TIMERUIApplication.h
//  webview
//
//  Created by palanichamy on 9/21/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

//the length of time before your application "times out". This number actually represents seconds, so we'll have to multiple it by 60 in the .m file


@interface TIMERUIApplication : UIApplication
{
    NSTimer     *myidleTimer;

}

-(void)resetIdleTimer;


@end
