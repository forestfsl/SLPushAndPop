//
//  SLNavigationDelegate.h
//  PushAndPop
//
//  Created by songlin on 2016/12/28.
//  Copyright © 2016年 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SLNavigationDelegate : NSObject<UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) NSUInteger operation;
@property (nonatomic,assign) NSTimeInterval duration;
@property (nonatomic,strong) UIViewPropertyAnimator  *transitionAnimator;

@end
