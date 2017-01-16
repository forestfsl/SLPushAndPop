//
//  ViewController.m
//  PushAndPop
//
//  Created by songlin on 2016/12/28.
//  Copyright © 2016年 songlin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [self converColor:0x007AFF];
}


-(UIColor *)converColor:(int)Hex {
    CGFloat red = (Hex >> 16) & 0xff;
    CGFloat green = (Hex >> 8) & 0xff;
    CGFloat blue = Hex & 0xff;
   return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
