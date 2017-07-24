//
//  LaunchImageView.h
//  XiaoyuDemo
//
//  Created by smallpay on 17/3/21.
//  Copyright © 2017年 yml. All rights reserved.
//

#import <UIKit/UIKit.h>

#define mainHeight      [[UIScreen mainScreen] bounds].size.height
#define mainWidth       [[UIScreen mainScreen] bounds].size.width

typedef enum{
    
    FullScreenLaunchType = 0,
    LogoLaunchType = 1,
    
}AddType;

typedef enum{
    
    AdvertLaunchType = 1,
    SkipLaunchType = 0,
    
}ClickType;

typedef void (^ClickBlock) (ClickType clickType);

@interface LaunchImageView : UIView{
    
    UIWindow * _window;
    UIImageView * _imgView;
    NSInteger _waitTime;//倒计时6秒
    NSInteger _secondTime;//3秒后可关闭
    UIButton * _skipBtn;
    
    ClickType _clickType;//点击类型（跳过、看广告）
    
}

@property(nonatomic, strong)NSTimer * timer;
@property(nonatomic, copy)ClickBlock clickBlock;

-(instancetype)initWithWindow:(UIWindow *)window Type:(AddType)type AddImageURL:(NSString *)urlStr;

-(void)skip;

@end
