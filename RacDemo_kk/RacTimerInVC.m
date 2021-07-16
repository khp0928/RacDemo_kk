//
//  RacTimerInVC.m
//  RacDemo_kk
//
//  Created by user on 2021/7/14.
//

#import "RacTimerInVC.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface RacTimerInVC ()

@property(nonatomic,strong) RACDisposable * disposable;/**ins*/

@property(nonatomic,strong) RACSignal * timeSignal;

@end

@implementation RacTimerInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self timerMethod];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)timerMethod{
    /**
     开启定时器。重复两秒一次。。。
     */
    @weakify(self);
//    [RACScheduler scheduler] 引用 globleQueue
//    [RACScheduler mainThreadScheduler] 引用mainQueue
    // return;
   self.disposable = [[RACSignal interval:2.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self);
        NSDateFormatter *forma = [[NSDateFormatter alloc] init];
        forma.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        NSString *dateStr = [forma stringFromDate:x];
        NSLog(@"!!!!interval:2.0 onScheduler %@",dateStr);

       [self.disposable dispose];//销毁timer 不调用不会随着控制器销毁停止。
    }];
    
    
    /**
     开启定时器。重复两秒一次。。。
     takeUntil:self.rac_willDeallocSignal 会随着控制器的销毁而停止。。。*/
    self.view.backgroundColor = [UIColor purpleColor];
    [[[RACSignal interval:2.0 onScheduler:[RACScheduler scheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
        NSDateFormatter *forma = [[NSDateFormatter alloc] init];
        forma.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        NSString *dateStr = [forma stringFromDate:x];
        NSLog(@"!!!!interval:2.0 onScheduler %@",dateStr);
    }];
    

    /**
        延迟3秒后执行。。  print：!!!! 我sendnext你
     */
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [subscriber sendNext:@"我sendnext你"]; // !!!!我sendnext你
        [subscriber sendNext:@""]; // !!!!
        return nil;
        }] delay:3.0] subscribeNext:^(id  _Nullable x) {
            NSLog(@"!!!! %@",x);
        }];
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
