//
//  SuccessViewController.m
//  Testkit
//
//  Created by Martin Prabhu on 10/20/15.
//  Copyright © 2015 test. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController

@synthesize jsondict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    jsondict=[[NSMutableDictionary alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResponseNew:) name:@"JSON_NEW" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSON_DICT" object:nil userInfo:nil];
    
}

-(void) ResponseNew:(NSNotification *)message
{
    if ([message.name isEqualToString:@"JSON_NEW"])
    {
        NSLog(@"Response = %@",[message object]);
        
        jsondict = [message object];
    }
    [self createPaymentDetailView];
}
-(void)createPaymentDetailView
{
    int YPOS=30;
    
    UILabel * tiltLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, YPOS,self.view.frame.size.width,50)];
    tiltLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:26];
    tiltLabel.backgroundColor = [UIColor clearColor];
    tiltLabel.text=@"Thank you for shopping";
    tiltLabel.textColor = [UIColor blackColor];
    tiltLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tiltLabel];
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-140)];
    scrollview.backgroundColor=[UIColor clearColor];
    NSLog(@"scroll width:%f",scrollview.frame.size.width);
    
    int x,gap,height,ypos = 0;
    int font_size;
    int labelWIdth;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        // iPad
        x=20,gap=20,height=40;
        font_size=17;
        labelWIdth=160;
        font_size=21;
        
    }
    else
    {
        // iPhone
        x=10,gap=10,height=30;
        font_size=13;
        labelWIdth=120;
        font_size=14;
    }
    NSArray *keyArray=[jsondict allKeys];
    
    for (int i=0;i<[keyArray count];i++)
    {
        NSString * responseString =[jsondict objectForKey:[keyArray objectAtIndex:i]];
        
        UILabel *listLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, ypos, self.view.frame.size.width-x*2, height)];
        
        listLabel.font = [UIFont fontWithName:@"Helvetica" size:font_size];
        
        listLabel.text=[NSString stringWithFormat:@"%@ : %@",[keyArray objectAtIndex:i],responseString];
        
        listLabel.backgroundColor = [UIColor clearColor];
        listLabel.textColor = [UIColor blackColor];
        
        listLabel.textAlignment = NSTextAlignmentLeft;
        
        ypos=listLabel.frame.origin.y+listLabel.frame.size.height+gap;
        
        [_scroll addSubview:listLabel];
    }
    
    int btnXPOS=self.view.frame.size.width/2-60;
    // ypos=self.view.frame.size.height-70;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    float redValues  =  [[[dict valueForKey:@"BUTTON_BG_COLOR"] valueForKey:@"Red"] floatValue];
    float greenValues = [[[dict valueForKey:@"BUTTON_BG_COLOR"] valueForKey:@"Green"]floatValue];
    float blueValues = [[[dict valueForKey:@"BUTTON_BG_COLOR"] valueForKey:@"Blue"]floatValue];
    float alphaValues =[[[dict valueForKey:@"BUTTON_BG_COLOR"] valueForKey:@"alpha"]floatValue];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(btnXPOS, ypos, 120, 40);
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = [UIColor colorWithRed:redValues/255.0 green:greenValues/255.0 blue:blueValues/255.0 alpha:alphaValues];
    [_scroll addSubview:submitBtn];
    
    // Submit Button Label
    UILabel *btnLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, submitBtn.frame.size.width, submitBtn.frame.size.height)];
    btnLabel.text=@"OK";
    btnLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:font_size+3];
    btnLabel.textColor=[UIColor whiteColor];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    [submitBtn addSubview:btnLabel];
    
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width,ypos+100);
    
    //[self.view addSubview:scrollview];
    
}
-(IBAction)submitAction:(id)sender
{
    /*********************************************************************************************************/
    //If you want to pop to previous view use below code, if you have your view controller on your view stack
    /*********************************************************************************************************/
    
    /*
     NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
     for (UIViewController *aViewController in allViewControllers)
     {
     NSString *strClass = NSStringFromClass([aViewController class]);
     
     if ([strClass isEqualToString:@"ViewController"])
     {
     [self.navigationController popToViewController:aViewController animated:NO];
     }
     }
     */
    
    
    /***********************************************************************************/
    //If you want to push to some other view controller using storyboard use below code
    /***********************************************************************************/
    /*
     UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
     
     TestKitViewController  *controller = (TestKitViewController*)[storyBoard instantiateViewControllerWithIdentifier: @"sampleViewController"];
     
     [self.navigationController pushViewController:controller animated:NO];
     */
    
    /*************************************************************************************/
    //If you want to push to some other view controller without storyboard but using xib use below code
    /*************************************************************************************/
    /*
     TestKitViewController *view2=[[TestKitViewController alloc]initWithNibName:@"TestKitViewController" bundle:nil];
     [self.navigationController pushViewController:view2 animated:YES];
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
