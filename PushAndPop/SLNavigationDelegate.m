//
//  SLNavigationDelegate.m
//  PushAndPop
//
//  Created by songlin on 2016/12/28.
//  Copyright © 2016年 songlin. All rights reserved.
//

#import "SLNavigationDelegate.h"



@implementation SLNavigationDelegate

-(instancetype)init {
    if (self = [super init]) {
        _operation = UINavigationControllerOperationPush;
        _duration = 5;
        _transitionAnimator = [[UIViewPropertyAnimator alloc]initWithDuration:1 timingParameters:[[UISpringTimingParameters alloc]initWithDampingRatio:1 initialVelocity:CGVectorMake(1, 0)]];
    }
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    self.operation = operation;
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    CGFloat translation = containerView.frame.size.width;
    translation = _operation == UINavigationControllerOperationPush ? translation : -translation;
    [containerView addSubview:toView];
    
    CGPoint center = toView.center;
      center.x += translation;
    toView.center = center;
    
    [self.transitionAnimator addAnimations:^{
        CGPoint fromCen = fromView.center;
        fromCen.x -= translation;
        fromView.center = fromCen;
        
        CGPoint toCen = toView.center;
        toCen.x -= translation;
        toView.center = toCen;
        
    }];
    
    [self.transitionAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        CGPoint containCen = containerView.center;
        containCen.y = fromView.center.y;
        fromView.center = containCen;
        toView.center = containCen;
        
        BOOL completed = finalPosition == UIViewAnimatingPositionEnd ? true : false;
        [transitionContext completeTransition:completed];
    }];
    [self.transitionAnimator startAnimation];
}


@end
