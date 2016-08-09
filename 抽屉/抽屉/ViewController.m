//
//  ViewController.m
//  抽屉
//
//  Created by niuwan on 16/7/21.
//  Copyright © 2016年 niuwan. All rights reserved.
//

#import "ViewController.h"

#define keyPath(obj, path) @(((void)obj.path, #path))
#define screeW [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //添加子视图
    [self setupChildView];
    
    //添加pan手试
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.view addGestureRecognizer:tap];
    
    
    //利用KVO时刻监听mainV的frame属性
//    [_mainV addObserver:self forKeyPath:keyPath(_mainV, frame) options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - 点按手势
- (void)tap {

    if (_mainV.frame.origin.x != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            
            _mainV.frame = self.view.bounds;
        }];
    }
}

//只要监听的属性一改变，就会调用观察者的这个方法，通知你有新值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSLog(@"%@",NSStringFromCGRect(_mainV.frame));
    if (_mainV.frame.origin.x > 0) {
        //mainV往右移
        _rightV.hidden = YES;
    }else if (_mainV.frame.origin.x < 0){
        //mainV往左移
        _rightV.hidden = NO;
    }
    
}

//- (void)dealloc {
//
//    [_mainV removeObserver:self forKeyPath:@"frame"];
//}

#define kTargetR 275
#define kTargetL -250
#pragma mark - 手试
- (void)pan:(UIPanGestureRecognizer *)pan {

    //获取手试的移动位置
    CGPoint transP = [pan translationInView:self.view];
    
    //获取X轴的偏移量
    CGFloat offsetX = transP.x;
    
    NSLog(@"======:%lf",offsetX);
    
    //修改main的frame
    _mainV.frame = [self frameWithOffsetX:offsetX];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
    //复位
    [pan setTranslation:CGPointZero inView:self.view];
    
    //判断手势的结束时mainView的位置
    if (pan.state == UIGestureRecognizerStateEnded) {
        //1.main.x > screenW *0.5
        CGFloat target = 0;
        if (_mainV.frame.origin.x > screeW * 0.5) {
            //点位到
            target = kTargetR;
        }else if(CGRectGetMaxX(_mainV.frame) < screeW * 0.5){
            //2.max(main.x) < screenW * 0.5
            target = kTargetL;
            
        }
        
        //获取x轴的偏移量
        offsetX = target - _mainV.frame.origin.x;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _mainV.frame = target == 0 ? self.view.bounds : [self frameWithOffsetX:offsetX];
            
        }];
        
        
    }

}
#define kMaxY 80
#pragma mark - 根据offsetX计算mainV的frame
- (CGRect)frameWithOffsetX:(CGFloat)offsetX {
    
     CGRect frame = _mainV.frame;
    //更具offsetX 计算offsetY
    CGFloat screeH = [UIScreen mainScreen].bounds.size.height;
    
    
    CGFloat offsetY= offsetX * kMaxY / screeW;
    
    //获取上次高度
    CGFloat preH = frame.size.height;
    
    //获取上次的宽度
    CGFloat preW = frame.size.width;
    
    //获取当前高度
    CGFloat curH = preH - 2 * offsetY;
    if (frame.origin.x < 0) {
        curH = preH + 2 * offsetY;
    }
    
    //获取缩放比例
    CGFloat scale = curH / preH;
    
    //获取当前宽度
    CGFloat curW = preW * scale;
    
    //获取当前x
    frame.origin.x += offsetX;
    
    //获取当前Y
    CGFloat y = (screeH - curH) *0.5;
    frame.origin.y = y;
    frame.size.height = curH;
    frame.size.width = curW;
   
    return frame;
}

#pragma mark - 子视图
- (void)setupChildView {

    //left
    UIView *leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    leftView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:leftView];
    _leftV = leftView;
    //right
    
    UIView *rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    
    rightView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:rightView];
    _rightV = rightView;
    //main
    
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    mainView.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainView];
    
    _mainV = mainView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
