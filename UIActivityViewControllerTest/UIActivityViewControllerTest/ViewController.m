//
//  ViewController.m
//  UIActivityViewControllerTest
//
//  Created by Tamás Zahola on 11/06/15.
//  Copyright (c) 2015 Tamás Zahola. All rights reserved.
//

#import "ViewController.h"

#define LOG_ENUM_CASE(x) case x: NSLog(@#x); break;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIViewController* viewController;

@end

@implementation ViewController

void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        LOG_ENUM_CASE(kCFRunLoopEntry)
        LOG_ENUM_CASE(kCFRunLoopBeforeTimers)
        LOG_ENUM_CASE(kCFRunLoopBeforeSources)
        LOG_ENUM_CASE(kCFRunLoopBeforeWaiting)
        LOG_ENUM_CASE(kCFRunLoopAfterWaiting)
        LOG_ENUM_CASE(kCFRunLoopExit)
            
        default:
            NSLog(@"Unhandled activity: %d", (int)activity);
            abort();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, kCFRunLoopAllActivities, YES, 0, runLoopObserverCallBack, NULL);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    
    self.viewController = [UIViewController new];
    self.viewController.view.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    [self.viewController.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"presentViewController:animated:completion:";
        case 1: return @"presentViewController:animated:completion: + CFRunLoopWakeUp";
            
        default:
            NSAssert(NO, @"Unhandled section: %d", (int)section);
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"present";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            NSLog(@"calling present");
            [self presentViewController:self.viewController animated:YES completion:nil];
            NSLog(@"called present");
            break;

        case 1:
            NSLog(@"calling present");
            [self presentViewController:self.viewController animated:YES completion:nil];
            NSLog(@"called present");
            
            NSLog(@"calling CFRunLoopWakeUp");
            CFRunLoopWakeUp(CFRunLoopGetCurrent());
            NSLog(@"called CFRunLoopWakeUp");
            break;
            
        default:
            break;
    }
}

@end
