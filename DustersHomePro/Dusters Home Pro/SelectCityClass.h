//
//  SelectCityClass.h
//  Dusters Home Pro
//
//  Created by Saurabh on 12/28/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectCityTableViewCell.h"


@protocol getCityProtocol <NSObject>

-(void)getCityName:(NSString *)cityName and :(NSString *)cityCode;

@end


@interface SelectCityClass : UIView<UITableViewDelegate,UITableViewDataSource>


-(void)alphaInitialize;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrantforView;
@property (strong, nonatomic) IBOutlet SelectCityTableViewCell *selectCityCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)id<getCityProtocol>delegate;
@end
