//
//  WgwMainViewController.m
//  抽屉
//
//  Created by niuwan on 16/7/23.
//  Copyright © 2016年 niuwan. All rights reserved.
//

#import "WgwMainViewController.h"
#import "WgwTVC.h"

@interface WgwMainViewController ()

@end

@implementation WgwMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建tableView控制器
    WgwTVC *mainTvc = [[WgwTVC alloc] init];
    mainTvc.view.frame = self.view.bounds;
    
    //保证mainTvc 不会释放
    [self addChildViewController:mainTvc];
    [self.mainV addSubview:mainTvc.view];
    
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
