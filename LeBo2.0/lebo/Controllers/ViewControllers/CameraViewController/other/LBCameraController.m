//
//  LBCameraController.m
//  LeBo
//
//  Created by 乐播 on 13-3-11.
//
//

#import "LBCameraController.h"

@interface LBCameraController ()

@end

@implementation LBCameraController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        LBCameraViewController * controller = [[LBCameraViewController alloc] init];
        UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        [navigation.navigationBar setTintColor:[UIColor darkGrayColor]];
        [navigation.navigationBar setTranslucent:YES];
        UIImage *bgimage = [UIImage imageNamed:@"naviBar_background.png"];

        //[navigation.navigationBar setBackgroundImage:Image(@"transparent.png") forBarMetrics:UIBarMetricsDefault];
        [navigation.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
        [self addChildViewController:navigation];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self main];
    [self performSelector:@selector(main) withObject:nil afterDelay:0.01];
}

- (void)main
{
    UIViewController * controller = self.childViewControllers[0];
    [self.view addSubview:controller.view];
}
@end
