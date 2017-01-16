//
//  InterruptibleNavigationControllerViewController.m
//  PushAndPop
//
//  Created by songlin on 2016/12/28.
//  Copyright © 2016年 songlin. All rights reserved.
//

#import "InterruptibleNavigationController.h"
#import "SLNavigationDelegate.h"

@interface InterruptibleNavigationController ()

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) SLNavigationDelegate   *navigationDelegate;
@property (nonatomic,assign) CGFloat fractionComplete;

@end

@implementation InterruptibleNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:self.pan];
    [self.view addGestureRecognizer:self.tap];
    self.navigationDelegate = [[SLNavigationDelegate alloc]init];
    self.delegate = self.navigationDelegate;
}


-(void)handleTap:(UITapGestureRecognizer *)tapGesture {
    UIViewPropertyAnimator *animator = self.navigationDelegate.transitionAnimator;
    switch (tapGesture.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            switch (animator.state) {
                case UIViewAnimatingStateActive:
                    [animator pauseAnimation];
                    [animator setReversed:!(animator.isReversed)];
                    [animator startAnimation];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

-(void)handlePan:(UIPanGestureRecognizer *)panGesture {
    UIViewPropertyAnimator *animator = self.navigationDelegate.transitionAnimator;
    CGFloat translationX = [panGesture translationInView:self.view].x;
    UINavigationControllerOperation operation = translationX > 0 ? UINavigationControllerOperationPop : UINavigationControllerOperationPush;
    CGFloat translationBase = self.view.frame.size.width;
    CGFloat translationAbs = translationX > 0 ? translationX : -translationX;
    CGFloat percent = translationAbs > translationBase ? 1.0 : translationX / translationBase;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            if (!animator.isRunning) {
                switch (operation) {
                    case UINavigationControllerOperationPop:
                        if (self.viewControllers.count == 2) {
                            [self popViewControllerAnimated:YES];
                        }
                        break;
                    case UINavigationControllerOperationPush:
                        if (self.viewControllers.count == 1) {
                            UIViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BlueVC"];
                            [self pushViewController:nextVC animated:YES];
                        }
                        break;
                    default:
                        break;
                }
            }else {
                [animator pauseAnimation];
                _fractionComplete = animator.fractionComplete;
            }
            break;
        case UIGestureRecognizerStateChanged:
            if (animator.isRunning) {
                [animator pauseAnimation];
                _fractionComplete = animator.fractionComplete;
            }else if (animator.state == UIViewAnimatingStateActive) {
                if (operation == _navigationDelegate.operation) {
                    animator.fractionComplete = fabs(percent) + _fractionComplete;
                }else {
                    animator.fractionComplete = _fractionComplete - fabs(percent);
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if (animator.state == UIViewAnimatingStateActive) {
                if (animator.fractionComplete < 0.3) {
                    [animator setReversed:true];
                }
                CGFloat velocityX = fabs([panGesture velocityInView:self.view].x) / (self.view.frame.size.width * (1 - animator.fractionComplete));
                CGVector initialVelocity = CGVectorMake(velocityX, 0);
                [animator continueAnimationWithTimingParameters:[[UISpringTimingParameters alloc]initWithDampingRatio:0.9 initialVelocity:initialVelocity] durationFactor:0];
            }
            break;
        default:
            break;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
