//
//  SOAnotherSwitch.h
//  CustomSwitch
//
//  Created by Sergey Oleynich on 11.08.15.
//  Copyright (c) 2015 Sergey Oleynich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOSwitch : UIView

@property (nonatomic, assign, getter=isOn) BOOL on;

@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *offImage;

@property (nonatomic, strong) UIColor *borderColor;
@property (assign, nonatomic) NSUInteger borderWidth;
@property (assign, nonatomic) NSUInteger cornerRadius;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
