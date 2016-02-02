//
//  SuperViewController.m
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/31.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)setBackButton:(NSString *)backStr{
    UIButton * back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(0, 0, 50, 50);
    [back setTitle:backStr forState:UIControlStateNormal];
    [back addTarget:self action:@selector(superBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];

}
-(void)setBackButtonImage:(NSString *)imageName{
    UIButton * back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(0, 0, 50, 50);
    [back setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(superBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
}
-(void)setSureButton:(NSString *)sureStr{
    
    UIButton * sure = [UIButton buttonWithType:UIButtonTypeSystem];
    sure.frame = CGRectMake(0, 0, 50, 50);
    [sure setTitle:sureStr forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(superSureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sure];
}
-(void)setSureButtonImage:(NSString *)imageName{
    UIButton * sure = [UIButton buttonWithType:UIButtonTypeSystem];
    sure.frame = CGRectMake(0, 0, 50, 50);
    [sure setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sure];

}

-(void)superBackBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)superSureBtnClicked{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
