//
//  LaunchImageView.m
//  XiaoyuDemo
//
//  Created by smallpay on 17/3/21.
//  Copyright © 2017年 yml. All rights reserved.
//

#import "LaunchImageView.h"
#import <ImageIO/ImageIO.h>

@implementation LaunchImageView

-(instancetype)initWithWindow:(UIWindow *)window Type:(AddType)type AddImageURL:(NSString *)urlStr{
    
    self = [super init];
    
    if (self) {
        
        _window = window;
        [_window makeKeyAndVisible];

        _waitTime = 0;
        _secondTime = 3;
        
        //获取图片
        CGSize viewSize = window.bounds.size;
        //竖屏
        NSString *viewOrientation = @"Portrait";
        
        NSString *launchImageName = nil;
        
        NSArray * imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        
        for (NSDictionary * dict in imagesDict) {
            
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
                
                launchImageName = dict[@"UILaunchImageName"];
                
            }
        }
        
        UIImage * launchImage = [UIImage imageNamed:launchImageName];
        self.backgroundColor = [UIColor colorWithPatternImage:launchImage];
        self.frame = CGRectMake(0, 0, mainWidth, mainHeight);
        if (type == FullScreenLaunchType) {
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight)];
            
        }else{
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight-mainWidth/3)];

        }

//        _imgView.backgroundColor = [UIColor colorWithPatternImage:launchImage];
        [self addSubview:_imgView];
        
        //添加图片手势
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        _imgView.userInteractionEnabled = YES;
        [_imgView addGestureRecognizer:tap];
        
        //添加一个gif图
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"fly" ofType:@"gif"];
//        NSData *gifData = [NSData dataWithContentsOfFile:path];
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//        webView.scalesPageToFit = YES;
//        [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:nil];
//        webView.backgroundColor = [UIColor clearColor];
//        webView.opaque = NO;
//        [self addSubview:webView];
        
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"fly" withExtension:@"gif"]; //加载GIF图片
        CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);           //将GIF图片转换成对应的图片源
        size_t frameCout = CGImageSourceGetCount(gifSource);                                         //获取其中图片源个数，即由多少帧图片组成
        NSMutableArray *frames = [[NSMutableArray alloc] init];                                      //定义数组存储拆分出来的图片
        for (size_t i = 0; i < frameCout; i++) {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL); //从GIF图片中取出源图片
            UIImage *imageName = [UIImage imageWithCGImage:imageRef];                  //将图片源转换成UIimageView能使用的图片源
            [frames addObject:imageName];                                              //将图片加入数组中
            CGImageRelease(imageRef);
        }
        UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        gifImageView.center = _imgView.center;
        gifImageView.animationImages = frames; //将图片数组加入UIImageView动画数组中
        gifImageView.animationDuration = 0.6; //每次动画时长
        [gifImageView startAnimating];         //开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
        [self addSubview:gifImageView];
        
        //创建skip按钮
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.frame = CGRectMake(mainWidth-70, 20, 60, 30);
        _skipBtn.backgroundColor = [UIColor brownColor];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_skipBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.hidden = YES;
        _skipBtn.selected = NO;
        [self addSubview:_skipBtn];
        
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_skipBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _skipBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        _skipBtn.layer.mask = maskLayer;
 
        //加载图片
        SDWebImageManager * manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:urlStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (error == nil) {
                _imgView.image = image;
            }else{
                _imgView.image = [UIImage imageNamed:@"advertIamge.jpg"];
            }
            
            _imgView.backgroundColor = [UIColor purpleColor];
            
        }];
        
        //添加动画
        CABasicAnimation * opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = 0.8;
        opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:0.8];
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [_imgView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ontimer) userInfo:Nil repeats:YES];
        
        [_window addSubview:self];
    }
    return self;
}

//跳过广告
-(void)skip{
    
    if (_skipBtn.selected) {
        _clickType = SkipLaunchType;
        
        [self startCloseAnimation];
    }
    
}

//轻点图片
-(void)tap{
    _clickType = AdvertLaunchType;

    [self startCloseAnimation];
}

//开启关闭动画
-(void)startCloseAnimation{
    
    [_timer invalidate];
    _timer = nil;
    
    if (_clickType == AdvertLaunchType) {//点击广告

        self.hidden = YES;
        if (self.clickBlock) {
            self.clickBlock(_clickType);
        }
    }
    else{//跳过
        
        CABasicAnimation * opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = 0.5;
        opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:0.3];
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
        
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.5f];//动画时间
        self.transform=CGAffineTransformMakeScale(2.0f, 2.0f);//放大
        [UIView commitAnimations]; //启动动画  

        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hiddeSelf) userInfo:nil repeats:NO];
        
        if (self.clickBlock) {
            self.clickBlock(_clickType);
        }
    }
}
-(void)hiddeSelf{
    
    self.hidden = YES;
    
}

//关闭动画完成处理事件
-(void)closeAddImgAnimation{
    
    [_timer invalidate];
    _timer = nil;
    
    self.hidden = YES;
    
    if (_clickType == AdvertLaunchType) {//点击广告
        if (self.clickBlock) {
            self.clickBlock(_clickType);
        }
    }
    else{//跳过
        if (self.clickBlock) {
            self.clickBlock(_clickType);
        }
    }
    
}

-(void)ontimer{
    
    _skipBtn.hidden = NO;
    
    if (_waitTime == 0) {
        _waitTime = 10;
    }

    if (_secondTime > 0) {
        [_skipBtn setTitle:[NSString stringWithFormat:@"%lds| 跳过",_secondTime] forState:UIControlStateNormal];
    }else{
        _skipBtn.selected = YES;
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    }
    
    if (_waitTime == 1) {
        
        [_timer invalidate];
        _timer = nil;
        [self startCloseAnimation];
    }
    
    _waitTime--;
    _secondTime--;
}

//压缩图片
-(UIImage *)imageCompressForWidth:(UIImage *)image MainWidth:(CGFloat)defineWidth{
    
    UIImage * newImage;
    CGSize imageSize = image.size;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height/width * targetWidth;
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if (CGSizeEqualToSize(imageSize, size) == NO) {
        
        CGFloat widthFactor = targetWidth/width;
        CGFloat heightFactor = targetHeight/height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight-scaledHeight)*0.5;
        }
        else{
            thumbnailPoint.x = (targetWidth-scaledWidth)*0.5;

        }
        
    }

    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [image drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (newImage == nil) {
        NSLog(@"处理图片失败！");

    }

    UIGraphicsEndImageContext();
    
    return newImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
