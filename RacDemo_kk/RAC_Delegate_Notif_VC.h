//
//  RAC_Delegate_Notif_VC.h
//  RacDemo_kk
//
//  Created by user on 2021/7/14.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RAC_Delegate_Notif_VC_Delegate <NSObject>

- (void)RacDelegateMethod:(NSString *)blockPara;

@end

@interface RAC_Delegate_Notif_VC : UIViewController

//代理方式1
@property(nonatomic,weak) id racDelegate;

//代理方式2
@property(nonatomic,strong) RACSubject * racSubject;/**ins*/

@end

NS_ASSUME_NONNULL_END
