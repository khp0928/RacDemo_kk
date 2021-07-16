//
//  RAC_Delegate_Notif_VC.m
//  RacDemo_kk
//
//  Created by user on 2021/7/14.
//

#import "RAC_Delegate_Notif_VC.h"

@interface RAC_Delegate_Notif_VC ()

@property(nonatomic,strong) UIButton * demoBtn;

@end

@implementation RAC_Delegate_Notif_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.demoBtn.backgroundColor = [UIColor purpleColor];
    
    
#pragma mark --  监听通知方法。。。
//    2021-07-15 17:47:57.498357+0800 RacDemo_kk[14952:17539761] -->NSConcreteNotification 0x6000029143f0 {name = notificationName; object = kang; userInfo = {
//        "!!key" = "!!value";
//    }}
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"notificationName" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            NSLog(@"-->%@", x);
    }];
    
}

- (UIButton *)demoBtn{
    if (!_demoBtn) {
        _demoBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 80)];
        [_demoBtn setTitle:@"按钮1" forState:UIControlStateNormal];
        [_demoBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _demoBtn.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [_demoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_demoBtn];
    }
    return _demoBtn;
}

- (void)btnClick:(UIButton *)btn{
    
    //代理方式1 代理方法执行。。
    if ([self.racDelegate respondsToSelector:@selector(RacDelegateMethod:)]) {
        [self.racDelegate RacDelegateMethod:@"！！！！RacDelegateMethod call ----》methodparas"];
    }
    //代理方式2
    if (self.racSubject) {
        [self.racSubject sendNext:@"！！！！RacDelegateMethod22 call ----》methodparas"];
    }
   
    //发送通知。。。
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:@"kang" userInfo:@{@"!!key":@"!!value"}];
}

 

@end
