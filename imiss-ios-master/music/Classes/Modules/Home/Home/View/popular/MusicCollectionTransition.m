//
//  MusicCollectionTransition.m
//  music
//
//  Created by zhongke on 2018/9/28.
//  Copyright © 2018年 kk. All rights reserved.
//

#import "MusicCollectionTransition.h"
#import "MusicController.h"

#pragma mark - 声明
@interface MusicCollectionTransition()

@property (nonatomic, weak) UIViewController *vc;
/**手势类型*/
@property (nonatomic, assign) MusicCollectionTransitionType type;

@end

#pragma mark - 实现
@implementation MusicCollectionTransition

#pragma mark - 初始化
+ (instancetype)transitionWithTransitionType:(MusicCollectionTransitionType)type {
    return [[self alloc] initWithTransitionType:type];
}
- (instancetype)initWithTransitionType:(MusicCollectionTransitionType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_type == MusicCollectionTransitionPresent) {
        return 0.8f;
    }
    else if (_type == MusicCollectionTransitionDismiss) {
        return 0.5f;
    }
    return 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
    switch (_type) {
        case MusicCollectionTransitionPresent:
            [self presentAnimation:transitionContext];
            break;
            
        case MusicCollectionTransitionDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}
// 实现present动画逻辑代码
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 首页
    HomeController *homeVC = ({
        BaseTabBarController *tab = (BaseTabBarController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        HomeController *vc = [(BaseNavigationController *)tab.childViewControllers[0] viewControllers][0];
        vc;
    });
    // 音乐
    MusicController *musicVC = (MusicController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:musicVC.view];
    
    
    
    //==================================== 专辑 ====================================
    UIImageView *icon = ({
        UIImageView *icon = [[UIImageView alloc] initWithFrame:[homeVC.selectCell.icon convertRectWithWindow]];
        [icon shadowWithColor:[UIColor clearColor] offset:CGSizeMake(0, 3) opacity:1 radius:5];
        [icon setImage:homeVC.selectCell.icon.image];
        icon;
    });
    [containerView addSubview:icon];
    
    // 专辑 - 中心
    POPBasicAnimation *iconBasic = ({
        CGRect rect = [musicVC.cd.icon convertRectWithWindow];
        POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basic.duration  = 0.5;
        basic.beginTime = CACurrentMediaTime();
        basic.toValue   = @(CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)));
        basic.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            musicVC.cd.icon.image = icon.image;
        };
        basic;
    });
    [icon pop_addAnimation:iconBasic forKey:@"iconBasic"];
    
    
    // 专辑 - 阴影
    POPBasicAnimation *shadowBasic = ({
        POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowColor];
        basic.duration  = 0.5;
        basic.beginTime = CACurrentMediaTime();
        basic.toValue   = (__bridge id)([kColor_Text_Gary colorWithAlphaComponent:0.5].CGColor);
        basic;
    });
    [icon.layer pop_addAnimation:shadowBasic forKey:@"shadowBasic"];
    
    
    // 专辑 - 比例
    CABasicAnimation *anim = ({
        CGFloat scale = musicVC.cd.icon.height / icon.height;
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1.f / 1000.f;
        transform = CATransform3DScale(transform, scale, scale, 1);
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        anim.duration     = 0.3;
        anim.beginTime    = CACurrentMediaTime();
        anim.autoreverses = NO;
        anim.toValue      = [NSValue valueWithCATransform3D:transform];
        anim.fillMode     = kCAFillModeForwards;
        anim.removedOnCompletion = NO;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim;
    });
    [icon.layer addAnimation:anim forKey:nil];
    
    
    
    // 首页文字
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        homeVC.header.top -= 10;
        homeVC.collection.nameLab.top += 20;
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    
    
    //==================================== 歌名 ====================================
    UIView *nameLab = ({
        UIView *lab = [homeVC.selectCell.nameLab snapshotViewAfterScreenUpdates:NO];
        [lab setFrame:[homeVC.selectCell.nameLab convertRectWithWindow]];
        [containerView addSubview:lab];
        lab;
    });
    
    // 歌名 - 位置
    POPBasicAnimation *nameBasic = ({
        CGRect rect = [musicVC.cd.nameLab convertRectWithWindow];
        POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basic.duration = 0.5;
        basic.beginTime = CACurrentMediaTime();
        basic.toValue = @(CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)));
        basic;
    });
    [nameLab pop_addAnimation:nameBasic forKey:@"nameBasic"];
    
    
    
    
    //==================================== 歌手 ====================================
    UIView *detailLab = ({
        UIView *detailLab = [homeVC.selectCell.detailLab snapshotViewAfterScreenUpdates:NO];
        [detailLab setFrame:[homeVC.selectCell.detailLab convertRectWithWindow]];
        [containerView addSubview:detailLab];
        detailLab;
    });
    
    // 歌手 - 位置
    POPBasicAnimation *detailBasic = ({
        CGRect rect = [musicVC.cd.detailLab convertRectWithWindow];
        POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basic.duration = 0.5;
        basic.beginTime = CACurrentMediaTime();
        basic.toValue = @(CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)));
        basic;
    });
    [detailLab pop_addAnimation:detailBasic forKey:@"detailBasic"];
    
    
    
    
    //==================================== 按钮 ====================================
    UIView *playBtn = ({
        UIView *playBtn = [homeVC.selectCell.playBtn snapshotViewAfterScreenUpdates:NO];
        [playBtn setFrame:[homeVC.selectCell.playBtn convertRectWithWindow]];
        [containerView addSubview:playBtn];
        playBtn;
    });
    
    // 歌手 - 位置
    POPBasicAnimation *playBasic = ({
        CGRect rect = [musicVC.bottom.controlBtn convertRectWithWindow];
        POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basic.duration = 1;
        basic.beginTime = CACurrentMediaTime();
        basic.toValue = @(CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)));
        basic;
    });
    [playBtn pop_addAnimation:playBasic forKey:@"playBasic"];
    
    // 歌手 - 旋转
    CABasicAnimation *playAnim = ({
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        anim.beginTime    = CACurrentMediaTime();
        anim.duration     = 0.5;
        anim.autoreverses = NO;
        anim.toValue      = [NSNumber numberWithFloat:M_PI * 2];
        anim.fillMode     = kCAFillModeForwards;
        anim.removedOnCompletion = NO;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim;
    });
    [playBtn.layer addAnimation:playAnim forKey:nil];
    
    
    
    
    [musicVC show];
    
    
    
    [homeVC.selectCell.icon setHidden:YES];
    [homeVC.selectCell.nameLab setHidden:YES];
    [homeVC.selectCell.detailLab setHidden:YES];
    [homeVC.selectCell.playBtn setHidden:YES];
    
    
    
    // 动画完成
    [playBasic setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        // 转场失败
        if ([transitionContext transitionWasCancelled]) {
            homeVC.selectCell.icon.hidden = NO;
        }
        // 转场成功
        else {
            [musicVC.cd setAlpha:1];
            [icon removeFromSuperview];
            [nameLab removeFromSuperview];
            [detailLab removeFromSuperview];
        }
    }];
}
// 实现dismiss动画逻辑代码
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    HomeController *homeVC = ({
        BaseTabBarController *tab = (BaseTabBarController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        HomeController *vc = [(BaseNavigationController *)tab.childViewControllers[0] viewControllers][0];
        vc;
    });
    MusicController *musicVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    // 首页文字
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        homeVC.header.top += 10;
        homeVC.collection.nameLab.top -= 20;
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    
    
    
    
    
    [musicVC hide];
    
    
    
    
    
    
    
    
    
    // [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    
}

@end
