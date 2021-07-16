//
//  ViewController.m
//  RacDemo_kk
//
//  Created by user on 2021/7/14.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RacTimerInVC.h"
#import "RAC_Delegate_Notif_VC.h"
#import "Rac_MoreViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UITextField *tf1;

@property (weak, nonatomic) IBOutlet UITextField *tf2;

@property(nonatomic,strong) RACSignal * timeSignal;

@property(nonatomic,copy) NSString * racObserveValue;/**<#ins#>*/


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
#pragma mark -- RAC常用类目
    [self moreSubscribe];
    
#pragma mark -- 基础监听
//    [self rac_UI];
    
    
#pragma mark -- valueforkeypath
//    [self rac_Observe];
//    self.racObserveValue = @"kang";
    
#pragma mark -- 遍历数组
//    NSArray * arr = @[@"",@"11",@"23",@"53",@"23"];
//    [arr.rac_sequence.signal subscribeNext:^(NSString * item) {
//        NSLog(@"!!!!item is :%@",item);
//    }];
//    NSDictionary * dicc = @{@"":@""};
//    dicc.rac_keySequence.signal
//    dicc.rac_valueSequence.signal
    
#pragma mark -- 监听通知、代理、方法
//   goto： - (IBAction)pushTimerVC:(id)sender
    
#pragma mark -- 信号量的一些混合用法。。
    //   goto： - (IBAction)pushTimerVC:(id)sender
 
}

#pragma mark -- RAC uitextField、btn相关
- (void)rac_UI {
    /**
     TF相关
     */
    //监听文本输入
    [[self.tf1 rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"!!!![self.tf1 rac_textSignal] subscribeNext: %@",x);
    }];
    //监听tf本身事件
    [[self.tf1 rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UITextField * _Nullable x) {
        NSLog(@"!!!!rac_signalForControlEvents: %@",x.text);
    }];
    //监听信号过滤。。。
    [[self.tf1.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return  value.length > 10;
        }] subscribeNext:^(NSString * _Nullable x) {
            NSLog(@"!!!!filter value.len > 10 is :%@",x);
        }];
//    rac_newTextChannel
    /**
     UIButton相关
     */
    [[self.btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"!!!!rac_signalForControlEvents--TouchUpInside");
    }];
    
     
    
}

#pragma mark -- RAC rac_valuesForKeyPath 、RAC
- (void)rac_Observe{
    //监听某一个变量变化
    [[self rac_valuesForKeyPath:@"racObserveValue" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_valuesForKeyPath : %@",x);
    }];
    //持有tf2的收入信号。。赋值给tf1
    RAC(self.tf1,text) = self.tf2.rac_textSignal;
}

#pragma mark --  了解多个订阅者  常用类目
- (void)moreSubscribe{
   
    
    
    bool runs = NO;
if (runs) {
        /**多个订阅者  replay的使用*/
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            static int a = 1;
            [subscriber sendNext:@(a)];
            a++;
            return nil;
        }] ;//订阅者1 get a is 1  订阅者2 get a is 2
        
        //    RACSignal *signal_replay = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //        static int a = 1;
        //        [subscriber sendNext:@(a)];
        //         a++;
        //          return nil;
        //      }] replay]; //订阅者1 get a is 1  订阅者2 get a is 1
        
        [signal subscribeNext:^(NSNumber * x) {
            
            NSLog(@"订阅者1 get a is %d",x.intValue); // 1
        }];
        [signal subscribeNext:^(NSNumber * x) {
            NSLog(@"订阅者2 get a is %d",x.intValue);// 2
        }];
    
    /**RACSignal类目*/
//    RACSignal *signa2 =  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//         [subscriber sendNext:@"hahahah"];
//         [subscriber sendCompleted];
//         return [RACDisposable disposableWithBlock:^{
//             NSLog(@"销毁了。。。");
//         }];
//     }];
//
//     [signa2 subscribeNext:^(id  _Nullable x) {
//         NSLog(@"!!!%@",x);
//         } error:^(NSError * _Nullable error) {
//             NSLog(@"!!!error....");
//         } completed:^{
//             NSLog(@"!!!complete....");
//         }];
     //2021-07-14 17:13:59.663634+0800 RacDemo_kk[11267:17001740] !!!hahahah
     //2021-07-14 17:13:59.663870+0800 RacDemo_kk[11267:17001740] !!!complete....
     //2021-07-14 17:13:59.664020+0800 RacDemo_kk[11267:17001740] 销毁了。。。
 
    /////RACSubject: RACSignal
//    RACSubject *subject = [RACSubject subject];
//    //订阅信号
//    [subject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"!!!!%@", x);
//    }];
//    //发送信号
//    [subject sendNext:@"信号dog"];
    
    /**RACTuple 类似于数组 A tuple is an ordered collection of objects*/
//    RACTuple *tube = [RACTuple tupleWithObjects:@"1",@"2", nil];
//    tupleWithObjectsFromArray
//    - (nullable id)objectAtIndex:(NSUInteger)index;
//    - (NSArray *)allObjects;
    
    /***RACMulticastConnection 的使用。。*/
//    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//          NSLog(@"net work request...耗时操作")
//        [subscriber sendNext:@"dogggggg"];
//        [subscriber sendCompleted];
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"return block signal销毁了");
//        }];
//    }];
    
//    初始有几个订阅者。。block执行几次。。去销毁。。。net work request...耗时操作执行两次。。。
//     2021-07-14 17:37:01.278058+0800 RacDemo_kk[11475:17029295] subscribeNext1---dogggggg
//     2021-07-14 17:37:01.278332+0800 RacDemo_kk[11475:17029295] !!!!complete
//     2021-07-14 17:37:01.278513+0800 RacDemo_kk[11475:17029295] return block signal销毁了
//     2021-07-14 17:37:01.278698+0800 RacDemo_kk[11475:17029295] subscribeNext2---dogggggg
//     2021-07-14 17:37:01.278818+0800 RacDemo_kk[11475:17029295] !!!!complete
//     2021-07-14 17:37:01.278938+0800 RacDemo_kk[11475:17029295] return block signal销毁了
//    [signal1 subscribeNext:^(id  _Nullable x) {
//        NSLog(@"subscribeNext1---%@",x);
//    } completed:^{
//        NSLog(@"!!!!complete");
//    }];
//    [signal1 subscribeNext:^(id  _Nullable x) {
//        NSLog(@"subscribeNext2---%@",x);
//    } completed:^{
//        NSLog(@"!!!!complete");
//    }];
    
//     初始定义的block只是最后执行了一次。。NSLog(@"net work request...耗时操作")这样只执行一次
//     2021-07-14 17:36:15.384524+0800 RacDemo_kk[11458:17028103] subscribeNext1--dogggggg
//     2021-07-14 17:36:15.384701+0800 RacDemo_kk[11458:17028103] subscribeNext2---dogggggg
//     2021-07-14 17:36:15.384834+0800 RacDemo_kk[11458:17028103] !!!!complete
//     2021-07-14 17:36:15.384929+0800 RacDemo_kk[11458:17028103] !!!!complete
//     2021-07-14 17:36:15.385063+0800 RacDemo_kk[11458:17028103] return block signal销毁了
     
    //        RACMulticastConnection *connection = [signal1 publish];
    //        [connection.signal subscribeNext:^(id  _Nullable x) {
    //            NSLog(@"subscribeNext1--%@",x);
    //        }completed:^{
    //            NSLog(@"!!!!complete");
    //        }];
    //        [connection.signal subscribeNext:^(id  _Nullable x) {
    //            NSLog(@"subscribeNext2---%@",x);
    //        }completed:^{
    //            NSLog(@"!!!!complete");
    //        }];
    //        [connection connect];
}
    
    /**RACDisposable*/
//    2021-07-16 13:46:14.971251+0800 RacDemo_kk[17081:17848484] 111sig_subscribeNext x == 哈哈哈
//    2021-07-16 13:46:14.971465+0800 RacDemo_kk[17081:17848484] 222sig_subscribeNext x == 哈哈哈
//    2021-07-16 13:46:14.971628+0800 RacDemo_kk[17081:17848484] 222sig_subscribeNext x == 呵呵呵

//    RACSubject *signal = [RACSubject subject];
//    //订阅信号,才会激活信号.
//    RACDisposable *dis1 = [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"111sig_subscribeNext x == %@",x);
//    }];
//
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"222sig_subscribeNext x == %@",x);
//    }];
//
//    [signal sendNext:@"哈哈哈"];
//
//    [dis1 dispose];
//
//    [signal sendNext:@"呵呵呵"];
     
}
 
- (IBAction)pushTimerVC:(id)sender {
    
#pragma mark -- 定时器方法
//    RacTimerInVC * tv = [[RacTimerInVC alloc] init];
//    [self presentViewController:tv animated:YES completion:nil];
    
#pragma mark --  delegate代理方法监听 and 通知监听方法
    
//    RAC_Delegate_Notif_VC * delevc = [[RAC_Delegate_Notif_VC alloc] init];
//    [self presentViewController:delevc animated:YES completion:nil];
//
    ////传统方式。。。
//    delevc.racDelegate = self;
//    实现- (void)RacDelegateMethod:(NSString *)blockPara
    
    
//// 方式一  rac方式  //<RAC_Delegate_Notif_VC_Delegate>不需要
//    [[self rac_signalForSelector:@selector(RacDelegateMethod:) fromProtocol:@protocol(RAC_Delegate_Notif_VC_Delegate)] subscribeNext:^(RACTuple * _Nullable x) {
//        //log:::: 2021-07-15 17:47:57.498043+0800 RacDemo_kk[14952:17539761] ！！！！methodparas
//        NSLog(@"代理方式1：%@",x.first);
//    }];
//    delevc.racDelegate = self;
    
    
    ////方式二。。利用信号量传递
    // log 代理方式2：！！！！RacDelegateMethod22 call ----》methodparas
//    delevc.racSubject = [RACSubject subject];
//    [delevc.racSubject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"代理方式2：%@",x);
//    }];
    
#pragma mark -- 信号量的一些混合用法。。。
    
    Rac_MoreViewController * vc = [[Rac_MoreViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
    
}

////原有代理方法调用。。。
//- (void)RacDelegateMethod:(NSString *)blockPara{
//
//}



@end
