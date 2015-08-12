//
//  SOAnotherSwitch.m
//  CustomSwitch
//
//  Created by Sergey Oleynich on 11.08.15.
//  Copyright (c) 2015 Sergey Oleynich. All rights reserved.
//

#import "SOSwitch.h"

@interface SOSwitch ()

@property (strong, nonatomic) UIImageView *movingImage;
@property (strong, nonatomic) UIImageView *backgroungImage;
@property (strong, nonatomic) UIView *knob;

@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL selector;

@property (assign, nonatomic) CGPoint offsetPoint;

@end

@implementation SOSwitch

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (CGRectGetHeight(frame) > CGRectGetWidth(frame)) {
        frame.size.width = CGRectGetHeight(frame);
        frame.size.height = CGRectGetWidth(frame);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = lrintf(CGRectGetHeight(self.bounds) / 4);
        self.layer.borderColor = [UIColor colorWithRed:181 / 255.f green:186 / 255.f blue:191 / 255.f alpha:1.f].CGColor;
        self.layer.borderWidth = 2.f;
        self.clipsToBounds = YES;
        
        [self addSubview:self.backgroungImage];
        
        _knob = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) - 0*2)];
        self.knob.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:181 / 255.f green:186 / 255.f blue:191 / 255.f alpha:1.f];
        [self addSubview:self.knob];

        [self.knob addSubview:self.movingImage];
        self.knob.layer.cornerRadius = lrintf(CGRectGetHeight(self.bounds) / 4);
        self.knob.clipsToBounds = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapKnob:)];
        [self.knob addGestureRecognizer:tapRecognizer];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panKnob:)];
        [self.knob addGestureRecognizer:panRecognizer];
        
        _on = NO;

    }
    return self;
}

- (void)dealloc {
    _movingImage = nil;
    _backgroungImage = nil;
    _onImage = nil;
    _offImage = nil;
    _knob = nil;
    _borderColor = nil;
}

#pragma mark - Getters

- (UIImageView *)movingImage {
    if (!_movingImage) {
        _movingImage = [[UIImageView alloc] init];
        _movingImage.frame = self.bounds;
        [_movingImage setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _movingImage;
}

- (UIImageView *)backgroungImage {
    if (!_backgroungImage) {
        _backgroungImage = [[UIImageView alloc] init];
        _backgroungImage.frame = self.bounds;
        [_backgroungImage setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _backgroungImage;
}

#pragma mark - Setters

- (void)setOnImage:(UIImage *)onImage {
    [self.movingImage setImage:onImage];
    _onImage = onImage;
}

- (void)setOffImage:(UIImage *)offImage {
    [self.backgroungImage setImage:offImage];
    _offImage = offImage;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)setCornerRadius:(NSUInteger)cornerRadius {
    if (cornerRadius > CGRectGetHeight(self.bounds) / 2) {
        cornerRadius = lrintf(CGRectGetHeight(self.bounds) / 2);
    }
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
    self.knob.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderWidth:(NSUInteger)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
    _knob.frame = CGRectMake(0, _borderWidth, CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) - _borderWidth * 2);
}

#pragma mark - Gesture

- (void)tapKnob:(UITapGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self];
    
    if (touchPoint.x < CGRectGetWidth(self.frame) / 2) {
        
         [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
             recognizer.view.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(recognizer.view.frame) / 2, recognizer.view.center.y);
             self.movingImage.center = CGPointMake (0, self.movingImage.center.y);
         } completion:^(BOOL finished) {
             _on = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
             [_target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
         }];
        
    } else {
        
        [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            recognizer.view.center = CGPointMake(CGRectGetWidth(recognizer.view.frame) / 2, recognizer.view.center.y);
            self.movingImage.center = CGPointMake (CGRectGetMidX(self.bounds), self.movingImage.center.y);
        } completion:^(BOOL finished) {
            _on = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
        }];
        
    }
}

- (void)panKnob:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self];
    
    UIView *view = recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.offsetPoint = CGPointMake(CGRectGetMidX(view.frame) - touchPoint.x,  self.movingImage.center.y);
    }
    
    view.center = CGPointMake(touchPoint.x + self.offsetPoint.x,  self.movingImage.center.y);
    self.movingImage.center = CGPointMake (CGRectGetMidX(self.bounds) - CGRectGetMinX(view.frame), self.movingImage.center.y);
    
    if (view.center.x >= CGRectGetWidth(self.frame) - CGRectGetWidth(view.frame) / 2) {
        view.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(recognizer.view.frame) / 2,  self.movingImage.center.y);
        self.movingImage.center = CGPointMake (0, self.movingImage.center.y);
        _on = YES;
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (_target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
            }
        }
        return ;
    }
    
    if (view.center.x <= CGRectGetWidth(view.frame) / 2) {
        view.center = CGPointMake(CGRectGetWidth(view.frame) / 2,  self.movingImage.center.y);
        self.movingImage.center = CGPointMake (CGRectGetMidX(self.bounds), self.movingImage.center.y);
        _on = NO;
        if (recognizer.state == UIGestureRecognizerStateEnded) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
        }
        return ;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (view.center.x <= CGRectGetMidX(self.bounds)) {
            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.center = CGPointMake(CGRectGetWidth(view.frame) / 2,  self.movingImage.center.y);
                self.movingImage.center = CGPointMake (CGRectGetMidX(self.bounds), self.movingImage.center.y);
            } completion:^(BOOL finished) {
                _on = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
            }];
        } else {
            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(recognizer.view.frame) / 2,  self.movingImage.center.y);
                self.movingImage.center = CGPointMake (0, self.movingImage.center.y);
            } completion:^(BOOL finished) {
                _on = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
            }];
        }
    }
    
}

#pragma mark - Public

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    _target = target;
    _selector = action;
}

@end








