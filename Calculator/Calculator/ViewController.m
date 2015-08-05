//
//  ViewController.m
//  Calculator
//
//  Created by team5 on 15/8/5.
//  Copyright (c) 2015年 Qunar.com. All rights reserved.
//

#import "ViewController.h"

#define ORANGE ([NSColor colorWithCalibratedRed:0.996f green:0.576f blue:0.255f alpha:1.00f])
#define CLEAR 100
#define NEG   101
#define ENTER 11

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
//        [[UINavigationBar appearance] setTranslucent:YES];
//    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _isInTheMiddleOfInputing = false;
    
    [self initScreen];
    
    
}

- (void) initScreen;
{
    CGFloat btnSideSize = 1/4.0*(self.view.bounds.size.width+1);
    
    // init display
    
    _display = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), (self.view.bounds.size.height - 5*btnSideSize + 80))];
    [_display setBackgroundColor:[UIColor blackColor]];
    [_display setText:@"0"];
    [_display setTextColor:[UIColor whiteColor]];
    [_display setTextAlignment:NSTextAlignmentRight];
    [_display setFont:[UIFont fontWithName:@"Helvetica Light" size:60.0]];
    [self.view addSubview:_display];
    
    // 19 buttons
    
    _clrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clrBtn setFrame:CGRectMake(0, self.view.bounds.size.height - 5*btnSideSize, btnSideSize, btnSideSize)];
    [_clrBtn setTitle:@"AC" forState:UIControlStateNormal];
    [_clrBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_clrBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:30.0]];
    [_clrBtn setBackgroundImage:[UIImage imageNamed:@"btn_others"] forState:UIControlStateNormal];
    [_clrBtn setBackgroundImage:[UIImage imageNamed:@"btn_digit_highlitened"] forState:UIControlStateHighlighted];
    [_clrBtn setTag:CLEAR];
    [_clrBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clrBtn];
    
    UIButton *positiveOrNagativeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [positiveOrNagativeBtn setFrame:CGRectMake(btnSideSize, self.view.bounds.size.height - 5*btnSideSize, btnSideSize, btnSideSize)];
    [positiveOrNagativeBtn setTitle:@"±" forState:UIControlStateNormal];
    [positiveOrNagativeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [positiveOrNagativeBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:30.0]];
    [positiveOrNagativeBtn setBackgroundImage:[UIImage imageNamed:@"btn_others"] forState:UIControlStateNormal];
    [positiveOrNagativeBtn setBackgroundImage:[UIImage imageNamed:@"btn_digit_highlitened"] forState:UIControlStateHighlighted];
    [positiveOrNagativeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [positiveOrNagativeBtn setTag:NEG];
    [self.view addSubview:positiveOrNagativeBtn];
    
    UIButton *modBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modBtn setFrame:CGRectMake(2 * btnSideSize, self.view.bounds.size.height - 5*btnSideSize, btnSideSize, btnSideSize)];
    [modBtn setTitle:@"%" forState:UIControlStateNormal];
    [modBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [modBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:30.0]];
    [modBtn setBackgroundImage:[UIImage imageNamed:@"btn_others"] forState:UIControlStateNormal];
    [modBtn setBackgroundImage:[UIImage imageNamed:@"btn_digit_highlitened"] forState:UIControlStateHighlighted];
    [modBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [modBtn setTag:16];
    [self.view addSubview:modBtn];
    
    NSArray *digitArray = @[@[@"7", @"8", @"9"],
                            @[@"4", @"5", @"6"],
                            @[@"1", @"2", @"3"]];
    
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *digitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [digitBtn setFrame:CGRectMake(j * btnSideSize, self.view.bounds.size.height - (4-i)*btnSideSize, btnSideSize, btnSideSize)];
            [digitBtn setTitle:[[digitArray objectAtIndex:i] objectAtIndex:j] forState:UIControlStateNormal];
            [digitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [digitBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:30.0]];
            [digitBtn setBackgroundImage:[UIImage imageNamed:@"btn_digit"] forState:UIControlStateNormal];
            [digitBtn setBackgroundImage:[UIImage imageNamed:@"btn_digit_highlitened"] forState:UIControlStateHighlighted];
            [digitBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [digitBtn setTag:[digitBtn.titleLabel.text integerValue]];
            [self.view addSubview:digitBtn];
            
        }
    }
    
    UIButton *zeroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zeroBtn setFrame:CGRectMake(0, self.view.bounds.size.height - btnSideSize, 2*btnSideSize, btnSideSize)];
    [zeroBtn setTitle:@"0" forState:UIControlStateNormal];
    [zeroBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    zeroBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentFill;
    [zeroBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:30.0]];
    [zeroBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    zeroBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 39.1, 0, 0);
    [zeroBtn setBackgroundImage:[UIImage imageNamed:@"btn_digit"] forState:UIControlStateNormal];
    [zeroBtn setBackgroundImage:[UIImage imageNamed:@"btn_digit_highlitened"] forState:UIControlStateHighlighted];
    [zeroBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [zeroBtn setTag:[zeroBtn.titleLabel.text integerValue]];
    [self.view addSubview:zeroBtn];
    
    UIButton *dotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dotBtn setFrame:CGRectMake(btnSideSize*2, self.view.bounds.size.height - btnSideSize, btnSideSize, btnSideSize)];
    [dotBtn setTitle:@"." forState:UIControlStateNormal];
    [dotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dotBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:30.0]];
    [dotBtn setBackgroundImage:[UIImage imageNamed:@"btn_digit"] forState:UIControlStateNormal];
    [dotBtn setBackgroundImage:[UIImage imageNamed:@"btn_digit_highlitened"] forState:UIControlStateHighlighted];
    [dotBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dotBtn setTag:10];
    [self.view addSubview:dotBtn];
    
    NSArray *operatorArray = @[@"÷", @"×", @"−", @"+", @"="];
    
    for (int i = 0; i < 5; i++) {
        UIButton *operatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [operatorBtn setFrame:CGRectMake(3*btnSideSize, self.view.bounds.size.height - (5-i)*btnSideSize, btnSideSize, btnSideSize)];
        [operatorBtn setTitle:[operatorArray objectAtIndex:i] forState:UIControlStateNormal];
        [operatorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [operatorBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:30.0]];
        [operatorBtn setBackgroundImage:[UIImage imageNamed:@"btn_operator"] forState:UIControlStateNormal];
        [operatorBtn setBackgroundImage:[UIImage imageNamed:@"btn_operator_highlitened"] forState:UIControlStateHighlighted];
        [operatorBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [operatorBtn setTag:15-i];
        [self.view addSubview:operatorBtn];
    }
    
}

- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    if ([btn.titleLabel.text isEqualToString:@"="]) {
        _isInTheMiddleOfInputing = false;
    }
    if (_isInTheMiddleOfInputing) {
        if (tag >= 0 && tag <= 10) {
            _display.text = [_display.text stringByAppendingString:btn.titleLabel.text];
        } else {
            
        }
        
    } else {
        if (tag > 0 && tag <= 10) {
            _isInTheMiddleOfInputing = true;
            _display.text = btn.titleLabel.text;
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
