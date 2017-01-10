//
//  SelectCityClass.m
//  Dusters Home Pro
//
//  Created by Saurabh on 12/28/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import "SelectCityClass.h"
#import "AppDelegate.h"
#import "Postman.h"
#import "Constant.h"
#import "SelectCityModel.h"
#import "MBProgressHUD.h"
#import "VMEnvironment.h"


@implementation SelectCityClass

    {
        UIView *view;
        UIControl *alphaView;
        NSMutableArray *tableArray;
        Postman *postman;
        SelectCityModel *cityModel;
        float tableHeight;
    
    }



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"SelectCityXib" owner:self options:nil]lastObject];
       [self addSubview:view];
    view.frame=self.bounds;
    //view.translatesAutoresizingMaskIntoConstraints = NO;
    //view.setNeedsLayout = YES;
    return self;
}

-(void)alphaInitialize{
   
    if (alphaView == nil)
    {
       
        view.frame = CGRectMake(25, 300, 300, 300);
        view.layer.cornerRadius = 10;
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    
    postman =[[Postman alloc]init];
    tableArray =[[NSMutableArray alloc]init];
    [self callApiForallCity];
    //monthArray=@[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    
    [alphaView addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];

    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cityModel = tableArray[indexPath.row];
    
    SelectCityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"selectCityTableCell" owner:self options:nil];
        cell=self.selectCityCell;
        self.selectCityCell=nil;
    }
    cell.cityLabel.text = cityModel.cityName;
    
    [self preferredContentSize];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    cityModel = tableArray[indexPath.row];
    //[self.delegate getCityName:cityModel.cityName];

    [self.delegate getCityName:cityModel.cityName and:cityModel.cityCode];
    
[self hideView];
}


- (CGFloat )preferredContentSize
{
    // Force the table view to calculate its height
    [self.tableView layoutIfNeeded];
    tableHeight = self.tableView.contentSize.height;
    self.heightConstrantforView.constant = tableHeight;
    
    return tableHeight;
}







-(void)hideView
{
    [alphaView removeFromSuperview];
}


-(void)callApiForallCity
{
    NSString *urlString =[NSString stringWithFormat:@"%@%@",base_url,getLocationURL];

    [MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    [postman get:urlString withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *responseData =[operation responseData];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        [self parsingResponseData:responseDict];
        [MBProgressHUD hideAllHUDsForView:alphaView animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:alphaView animated:YES];
    }];
 }


-(void)parsingResponseData:(NSDictionary *)resposeDict
{

    NSLog(@"%@",resposeDict);
    NSMutableArray *cityArr = resposeDict[@"ViewModels"];
    for (NSDictionary *aDict in cityArr) {
        if ([aDict[@"Status"]boolValue]) {
            cityModel =[[SelectCityModel alloc]init];
            cityModel.cityName = aDict[@"Name"];
            cityModel.cityCode = aDict[@"Code"];
            [tableArray addObject:cityModel];
        }
        
        
    }
    [self.tableView reloadData];
    

}
















@end
