//
//  NormalDefine.h
//  XiaoyuDemo
//
//  Created by smallpay on 17/3/22.
//  Copyright © 2017年 yml. All rights reserved.
//

#ifndef NormalDefine_h
#define NormalDefine_h

//屏幕宽高
#define deviceHeitht [[UIScreen mainScreen] bounds].size.height
#define deviceWidth [[UIScreen mainScreen] bounds].size.width


#ifdef DEBUG
    #define Mylog(...) NSLog(__VA_ARGS__)
#else
    #define Mylog(...)
#endif


#endif /* NormalDefine_h */
