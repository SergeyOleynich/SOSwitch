//
//  ViewController.m
//  CustomSwitch
//
//  Created by Sergey Oleynich on 07.08.15.
//  Copyright (c) 2015 Sergey Oleynich. All rights reserved.
//

#import "ViewController.h"
#import "SOSwitch.h"
#import "SOSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        
    SOSwitch *cSwitch = [[SOSwitch alloc] initWithFrame:CGRectMake(20, 250, 150, 50)];
    cSwitch.borderColor = [UIColor redColor];
    [cSwitch addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:cSwitch];
    
}

- (void)change:(SOSwitch *)cSwitch {
    NSLog(cSwitch.isOn ? @"Yes" : @"No");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
