
#import "SelectTime.h"


@implementation SelectTime
{
     UIControl  *alphaView;
    UIView *view;
    NSMutableArray *array;
 }
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    NSLog(@"%f",self.frame.size.width);
    view=[[[NSBundle mainBundle]loadNibNamed:@"SelectTime" owner:self options:nil]lastObject];
    view.frame=self.bounds;
    NSLog(@"%@",NSStringFromCGRect(view.frame));
     NSLog(@"%@",NSStringFromCGRect(view.frame));
    [self addSubview:view];
    
     return self;
   }
-(void)alphaInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [alphaView addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
     view.layer.cornerRadius=10;
    view.layer.masksToBounds=YES;
    [_tableView reloadData];
    [self tableviewHeight];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectTimeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectTimeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
    [[NSBundle mainBundle]loadNibNamed:@"SelectTimeCell" owner:self options:nil];
    cell=self.selectTimeCell;
    self.selectTimeCell=nil;
    }
    cell.timeLabel.text=self.selectTimeArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str=self.selectTimeArray[indexPath.row];
    [self.delegate SelectTime:str];
    [self hideView];

}
-(void)tableviewHeight
{
    CGFloat height = self.tableView.contentSize.height +50;
    if (height>400) {
        height=400;
    }
    CGRect frame=self.frame;
    frame.size.height=height;
    self.frame=frame;
    view.frame=self.bounds;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    view.center = appDel.window.center;
}

-(void)hideView
{
    [alphaView removeFromSuperview];
}
@end
