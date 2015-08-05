//
//  ViewController.h
//  Calculator
//
//  Created by team5 on 15/8/5.
//  Copyright (c) 2015年 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (assign, nonatomic) BOOL      isInTheMiddleOfInputing;
@property (strong, nonatomic) UILabel  *display;
@property (strong, nonatomic) UIButton *clrBtn;

@end

