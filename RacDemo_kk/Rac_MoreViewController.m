//
//  Rac_MoreViewController.m
//  RacDemo_kk
//
//  Created by user on 2021/7/14.
//

#import "Rac_MoreViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface Rac_MoreViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;

@end

@implementation Rac_MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSubject * aSubject = [RACSubject subject];
    RACSubject * bSubject = [RACSubject subject];
   
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"signal2 block run...");
        [subscriber sendNext:@"signal2 "];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"signal2 delloc");
        }];
    }];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"signal1 block run...");
            [subscriber sendNext:@"signal1 "];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"signal1 delloc");
            }];
        }];
    
    #pragma mark -- concat
    /**
     concat  有序接收信号 [signal1 concat:signal2] 先接收1的send  再接收2的send
     ！！！注意:第一个信号必须调用sendCompleted
     */
//    2021-07-15 10:37:40.378598+0800 RacDemo_kk[12509:17187304] signal3-->signal1
//    2021-07-15 10:37:40.378840+0800 RacDemo_kk[12509:17187304] signal3-->signal2
//    2021-07-15 10:37:40.378976+0800 RacDemo_kk[12509:17187304] signal2 delloc
//    2021-07-15 10:37:40.379167+0800 RacDemo_kk[12509:17187304] signal1 delloc
//    RACSignal *signal3 = [signal1 concat:signal2];
//        [signal3 subscribeNext:^(id  _Nullable x) {
//            NSLog(@"signal3-->%@",x);
//        }];
    
#pragma mark --combineLatestWith
    /***combineLatestWith 捆绑信号 触发next操作（必须捆绑的信号都被触发）。。
     。如果其中有的信号没有send。则不触发combineLatestWith*/
//    2021-07-15 10:41:45.579540+0800 RacDemo_kk[12584:17194523] signal1 delloc
//    2021-07-15 10:41:45.580068+0800 RacDemo_kk[12584:17194523] ！！！<RACTwoTuple: 0x600003c55580> (
//        "signal1 ",
//        "signal2 "
//    )
//    2021-07-15 10:41:45.580506+0800 RacDemo_kk[12584:17194523] signal2 delloc
//    RACSignal *signal3 = [signal1 combineLatestWith:signal2];
//    [signal3 subscribeNext:^(RACTuple* x) {
//           NSLog(@"！！！%@",x);
//       }];
#pragma mark --merge
    /***merge 捆绑信号 主要有捆绑内的信号被触发。都会调用。。
        区别于combine*/
//    1 信号都存在的时候
//    2021-07-15 11:17:12.841389+0800 RacDemo_kk[12876:17228441] signal1 block run...
//    2021-07-15 11:17:12.841681+0800 RacDemo_kk[12876:17228441] ！！！--signal1
//    2021-07-15 11:17:12.841926+0800 RacDemo_kk[12876:17228441] signal1 delloc
//    2021-07-15 11:17:12.842223+0800 RacDemo_kk[12876:17228441] signal2 block run...
//    2021-07-15 11:17:12.842405+0800 RacDemo_kk[12876:17228441] ！！！--signal2
//    2021-07-15 11:17:12.842553+0800 RacDemo_kk[12876:17228441] signal2 delloc
//    2 注释掉信号1的时候
//    2021-07-15 11:18:21.728050+0800 RacDemo_kk[12890:17230048] signal1 block run...
//    2021-07-15 11:18:21.728292+0800 RacDemo_kk[12890:17230048] signal1 delloc
//    2021-07-15 11:18:21.728460+0800 RacDemo_kk[12890:17230048] signal2 block run...
//    2021-07-15 11:18:21.728620+0800 RacDemo_kk[12890:17230048] ！！！--signal2
//    2021-07-15 11:18:21.728772+0800 RacDemo_kk[12890:17230048] signal2 delloc
//      RACSignal *signal3 = [signal1 merge:signal2];
//      [signal3 subscribeNext:^(RACTuple* x) {
//           NSLog(@"！！！--%@",x);
//      }];
    
    
#pragma mark --then
    /**
     then 先执行signal1的block  完成后。。再接收signal2的信号。。。
     */
//    2021-07-15 11:05:29.161628+0800 RacDemo_kk[12749:17218611] signal1 block run...
//    2021-07-15 11:05:32.895118+0800 RacDemo_kk[12749:17218611] signal2 block run...
//    2021-07-15 11:05:32.895344+0800 RacDemo_kk[12749:17218611] signal4--signal2
//    2021-07-15 11:05:36.220775+0800 RacDemo_kk[12749:17218611] signal4 complete..
//    2021-07-15 11:05:36.220954+0800 RacDemo_kk[12749:17218611] signal2 delloc
//    2021-07-15 11:05:36.221081+0800 RacDemo_kk[12749:17218611] signal1 delloc
//    RACSignal * signal4 = [signal1 then:^RACSignal * _Nonnull{
//        return signal2;
//    }];
//    [signal4 subscribeNext:^(id  _Nullable x) {
//        NSLog(@"signal4--%@",x);
//    } completed:^{
//            NSLog(@"signal4 complete..");
//    }];
#pragma mark --reduce
    /***
     reduce 聚合  把多个信号的值按照自定义的组合返回
     */
//    2021-07-15 13:59:19.746923+0800 RacDemo_kk[13576:17348527] signal1 block run...
//    2021-07-15 13:59:19.747337+0800 RacDemo_kk[13576:17348527] signal1 delloc
//    2021-07-15 13:59:19.747543+0800 RacDemo_kk[13576:17348527] signal2 block run...
//    2021-07-15 13:59:19.747901+0800 RacDemo_kk[13576:17348527] !!!!-signal1 --signal2
//    2021-07-15 13:59:19.748125+0800 RacDemo_kk[13576:17348527] signal2 delloc
//    RACSignal * reduceSig = [RACSignal combineLatest:@[signal1,signal2]  reduce:^id (NSString *s1 ,NSString *s2){
//        return [NSString stringWithFormat:@"%@--%@",s1,s2];
//    }];
//    [reduceSig subscribeNext:^(id  _Nullable x) {
//        NSLog(@"!!!!-%@",x);
//    }];
    
//    RACSignal *signalA = self.textField.rac_textSignal;
//       RACSignal *signalB = [self.button rac_signalForControlEvents:UIControlEventTouchUpInside];
//       RACSignal *reduceSignal = [RACSignal combineLatest:@[signalA,signalB] reduce:^id (NSString *textFieldText,UIButton *value2 ){
//           return [NSString stringWithFormat:@"reduce == %@ %@",textFieldText,value2];
//       }];
//       [reduceSignal subscribeNext:^(id  _Nullable x) {
//           NSLog(@"subscribeNext %@",x);
//       }];
    
#pragma mark --combineLatest 、 zipwith、zip取值sample
    /***
     combine 、 zipwith、zip取值sample
     
     */
//    1、combine
//    RACSignal *combinelatest = [RACSignal combineLatest:@[aSubject,bSubject] reduce:^id (NSString * as ,NSString * bs){
//        return [NSString stringWithFormat:@"[%@+%@]",as,bs];
//    }];
    
//    2021-07-15 14:05:32.721972+0800 RacDemo_kk[13620:17354669] combinelatest-->:[B+1]
//    2021-07-15 14:05:32.722268+0800 RacDemo_kk[13620:17354669] combinelatest-->:[B+2]
//    2021-07-15 14:05:32.722512+0800 RacDemo_kk[13620:17354669] combinelatest-->:[C+2]
//    2021-07-15 14:05:32.722784+0800 RacDemo_kk[13620:17354669] combinelatest-->:[C+3]
//    2021-07-15 14:05:32.723000+0800 RacDemo_kk[13620:17354669] combinelatest-->:[D+3]
//    2021-07-15 14:05:32.723246+0800 RacDemo_kk[13620:17354669] combinelatest-->:[D+4]
// 可以看到。只要a/b都有值。。只要sendNext出现。。combine触发。且取值a和b最新一对值。然后继续保留当前最新值继续。。。
//    [combinelatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"combinelatest-->:%@",x);
//    }];
//
//    [aSubject sendNext:@"A"];
//    [aSubject sendNext:@"B"];
//    [bSubject sendNext:@"1"];
//    [bSubject sendNext:@"2"];
//    [aSubject sendNext:@"C"];
//    [bSubject sendNext:@"3"];
//    [aSubject sendNext:@"D"];
//    [bSubject sendNext:@"4"];
    
    
//    2、zip
//    RACSignal *ziplatest = [RACSignal zip:@[aSubject,bSubject] reduce:^id (NSString * as ,NSString * bs){
//        return [NSString stringWithFormat:@"[%@+%@]",as,bs];
//    }];
////    2021-07-15 14:14:23.942338+0800 RacDemo_kk[13683:17363096] combinelatest-->:[A+3]
////    2021-07-15 14:14:23.942700+0800 RacDemo_kk[13683:17363096] combinelatest-->:[B+4]
////    2021-07-15 14:14:23.942886+0800 RacDemo_kk[13683:17363096] combinelatest-->:[C+1]
////    2021-07-15 14:14:23.943112+0800 RacDemo_kk[13683:17363096] combinelatest-->:[D+2]
//// 可以看到。zip优先取先入值，后入的暂存。。只要a/b都有值。。zip触发。取先入值。然后直接放弃老值取下一值再继续。。
//    [ziplatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"combinelatest-->:%@",x);
//    }];
//
//    [aSubject sendNext:@"A"];
//    [aSubject sendNext:@"B"];
//    [aSubject sendNext:@"C"];
//    [bSubject sendNext:@"3"];
//    [aSubject sendNext:@"D"];
//    [bSubject sendNext:@"4"];
//    [bSubject sendNext:@"1"];
//    [bSubject sendNext:@"2"];
    
    //    3、zip取值sample   A sample B  == 当B信号产生时候 取A最新值。。。
//    RACSignal * sampleSub = [bSubject sample:aSubject];
//    RACSignal *zip_sample = [RACSignal zip:@[aSubject,sampleSub] reduce:^id (NSString * as ,NSString * bs){
//            return [NSString stringWithFormat:@"[%@+%@]",as,bs];
//        }];
////    2021-07-15 14:31:48.765163+0800 RacDemo_kk[13841:17382320] zip_sample-->:[A+2]
////    2021-07-15 14:31:48.765596+0800 RacDemo_kk[13841:17382320] zip_sample-->:[B+2]
////    2021-07-15 14:31:48.765900+0800 RacDemo_kk[13841:17382320] zip_sample-->:[C+3]
//    // 可以看到。aSubject依旧保持zip方式。优先取先入值，后入的暂存。取一次后放弃。。继续取下一个。。
////    此时sample方式。则是只有a信号到来的时候获取b最新值。。每次都获取最新值。即便它是取过的旧值。。
//        [zip_sample subscribeNext:^(id  _Nullable x) {
//            NSLog(@"zip_sample-->:%@",x);
//        }];
//
//        [aSubject sendNext:@"A"];
//        [aSubject sendNext:@"B"];
//        [bSubject sendNext:@"1"];
//        [bSubject sendNext:@"2"];
//        [aSubject sendNext:@"C"];
//        [aSubject sendNext:@"m"];
//        [bSubject sendNext:@"3"];
//        [aSubject sendNext:@"D"];
//        [bSubject sendNext:@"4"];
    
    
    
#pragma mark --flattenMap map
       /***
        flattenMap & map 映射
        用于信号中信号,把源信号的内容映射成一个新的信号,信号可以是任意类型
        1. FlatternMap 中的Block 返回信号.
        2. Map 中的Block 返回对象.
        3. 开发中,如果信号发出的值不是信号,映射一般使用Map.
        4. 开发中,如果信号发出的值是信号,映射一般使用FlatternMap.
        参考 https://www.jianshu.com/p/42d4730ae8f5
        */
//    [[self.tf1.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return [NSString stringWithFormat:@"0316-[%@]",value];
//        }] subscribeNext:^(id  _Nullable x) {
//            NSLog(@"!!!!-x:%@",x);
//        }
//     ];
//    [[self.tf2.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
//
//            return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//                [subscriber sendNext:[NSString stringWithFormat:@"0316-[%@]",value]];
//                [subscriber sendCompleted];
//                return  [RACDisposable disposableWithBlock:^{}];
//            }];
//
//        }] subscribeNext:^(id  _Nullable x) {
//            NSLog(@"！！！！-----%@",x);
//        }];
    
//    实例map
    //创建一个信号
//      RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//         //这个信号里面有一个Next事件的玻璃球和一个complete事件的玻璃球
//          [subscriber sendNext:@"唱歌"];
//          [subscriber sendCompleted];
//          return nil;
//
//      }];
//
//      //对信号进行改进,当信号里面流的是唱歌.就改进为'跳舞'返还给self.value
//
//      RAC(self, tF.text) = [signalA map:^id(NSString *value) {
//          if ([value isEqualToString:@"唱歌"]) {
//              return @"跳舞";
//          }
//          return @"";
//
//      }];
    
//     实例demoflattenmap
//    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//           NSLog(@"打蛋液");
//           [subscriber sendNext:@"蛋液"];
//           [subscriber sendCompleted];
//           return nil;
//
//       }];
//       //对信号进行秩序秩序的第一步
//       siganl = [siganl flattenMap:^RACSignal *(NSString *value) {
//           //处理上一步的RACSiganl的信号value.这里的value=@"蛋液"
//           NSLog(@"把%@倒进锅里面煎",value);
//           return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//               [subscriber sendNext:@"煎蛋"];
//               [subscriber sendCompleted];
//               return nil;
//
//           }];
//
//       }];
//       //对信号进行第二步处理
//       siganl = [siganl flattenMap:^RACSignal *(id value) {
//           NSLog(@"把%@装载盘里",value);
//           return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//               [subscriber sendNext:@"上菜"];
//               [subscriber sendCompleted];
//               return nil;
//           }];
//
//       }];
//
//       //最后打印 最后带有===上菜
//       [siganl subscribeNext:^(id x) {
//           NSLog(@"====%@",x);
//       }];
   
#pragma mark --filter/filter/distinctUntilChanged
    /***
     filter 条件过滤信号值
     filter 条件忽略某种信号值
     distinctUntilChanged直到信号不同才触发
     */
//    [[self.tf1.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
//        return  value.length > 2;
//        }] subscribeNext:^(NSString * _Nullable x) {
//            NSLog(@"filter :---%@",x);
//        }];
//
//    [[self.tf1.rac_textSignal ignore:@"123"] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"ignore :---%@",x);
//    }];
////    2021-07-15 15:25:27.958729+0800 RacDemo_kk[14133:17428818] distinctUntilChanged :---123
////    2021-07-15 15:25:27.958973+0800 RacDemo_kk[14133:17428818] distinctUntilChanged :---345
//    [[aSubject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"distinctUntilChanged :---%@",x);
//    }];
//    [aSubject sendNext:@"123"];
//    [aSubject sendNext:@"123"];
//    [aSubject sendNext:@"345"];
     
#pragma mark --takeUntil
    /***
     subjectA takeUntil:subjectB 有点A依赖B的意思。。B是开关。。只要B发送信号或者完成。。。A就发送不了了
     */
//    RACSubject *subjectA = [RACSubject subject];
//    RACSubject *subjectB = [RACSubject subject];
//    [[subjectA takeUntil:subjectB] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
//    [subjectA sendNext:@"A"];
//    [subjectA sendNext:@"B"];
//    [subjectA sendNext:@"C"];
//
//    [subjectB sendNext:@"C"]; //或者 [subjectB sendCompleted];;
//
//    [subjectA sendNext:@"D"];//不打印
    
#pragma mark --command
    /***
     
     A command is a signal triggered in response to some action, typically
     /// UI-related.
     */
//    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            NSLog(@"commandblock run--> [%@]",input);
//            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                return nil;
//            }];
//
//        }];
//
//        //执行命令
//        [command execute:@"commandExcute"];
    
    #pragma mark -- RACReplaySubject  保存send信号，给每个订阅发发放
//    2021-07-16 10:16:39.533060+0800 RacDemo_kk[16152:17692044] sub 1.....
//    2021-07-16 10:16:39.533289+0800 RacDemo_kk[16152:17692044] sub 2....
//    2021-07-16 10:16:39.533458+0800 RacDemo_kk[16152:17692044] sub 1.....
//    2021-07-16 10:16:39.533590+0800 RacDemo_kk[16152:17692044] sub 2....
//    2021-07-16 10:16:39.534133+0800 RacDemo_kk[16152:17692044] sub 3....
//    2021-07-16 10:16:39.534273+0800 RacDemo_kk[16152:17692044] sub 3....
    //可见。不管send时机是何时。。都会保存下消息。。给后来的订阅者接收。。
//    RACReplaySubject * sig =  [RACReplaySubject subject];
//
//    [sig subscribeNext:^(id  _Nullable x) {
//        NSLog(@"sub 1.....");
//    }];
//
//    [sig subscribeNext:^(id  _Nullable x) {
//        NSLog(@"sub 2....");
//    }];
//
//    [sig sendNext:@"1 and 2 after sentMSG1"];
//    [sig sendNext:@"1 and 2 after sentMSG2"];
//
//    [sig subscribeNext:^(id  _Nullable x) {
//        NSLog(@"sub 3....");
//    }];
    
    #pragma mark -- rac_liftSelector 信号处理有点类似combineLatast 待所有信号都到后。执行方法调用。。保存了两条队列。获取最新值。。
//    2021-07-16 10:29:09.112666+0800 RacDemo_kk[16285:17705511] rac_liftSelector--p1:A1----p2:B2
//    2021-07-16 10:29:09.113138+0800 RacDemo_kk[16285:17705511] rac_liftSelector--p1:A2----p2:B2
//    2021-07-16 10:29:09.113501+0800 RacDemo_kk[16285:17705511] rac_liftSelector--p1:A3----p2:B2
    RACSignal *sigalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [subscriber sendNext:@"A1"];
              [subscriber sendNext:@"A2"];
              [subscriber sendNext:@"A3"];
          });
          return nil;
      }];
      
      RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
          [subscriber sendNext:@"B1"];
          [subscriber sendNext:@"B2"];
          [subscriber sendCompleted];
          return nil;
          
      }];
    [self rac_liftSelector:@selector(liftSelctorPara1:para2:) withSignals:sigalA,signalB, nil];
     
}

- (void)liftSelctorPara1:(NSString *)para1 para2:(NSString *)para2{
    NSLog(@"rac_liftSelector--p1:%@----p2:%@",para1,para2);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

 


@end
