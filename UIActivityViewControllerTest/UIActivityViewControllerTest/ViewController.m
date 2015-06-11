//
//  ViewController.m
//  UIActivityViewControllerTest
//
//  Created by Tamás Zahola on 11/06/15.
//  Copyright (c) 2015 Tamás Zahola. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
            
        case 1:
        case 2: return 3;
            
        default:
            NSAssert(NO, @"Unhandled section: %d", (int)section);
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"showViewController:sender:";
        case 1: return @"presentViewController:animated:completion:";
        case 2: return @"presentViewController:animated:completion: + dispatch ^{} to main queue";
            
        default:
            NSAssert(NO, @"Unhandled section: %d", (int)section);
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"UIViewController";
            break;
        case 1:
            cell.textLabel.text = @"UIActivityViewController";
            break;
        case 2:
            cell.textLabel.text = @"UIAlertController";
            break;
        default:
            NSAssert(NO, @"Unhandled row: %@", indexPath);
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController* viewController = [self viewControllerForRow:indexPath.row];
    switch (indexPath.section) {
        case 0:
            [self showViewController:viewController sender:self];
            break;
            
        case 1:
            [self presentViewController:viewController animated:YES completion:nil];
            break;
            
        case 2:
            [self presentViewController:viewController animated:YES completion:nil];
            dispatch_async(dispatch_get_main_queue(), ^{});
            break;
            
        default:
            break;
    }
}

- (UIViewController*)viewControllerForRow:(NSInteger)row {
    switch (row) {
        case 0: {
            UIViewController* viewController = [UIViewController new];
            viewController.view.backgroundColor = [UIColor redColor];
            UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
            [viewController.view addGestureRecognizer:tapGestureRecognizer];
            return viewController;
        } break;
            
        case 1: {
            return [[UIActivityViewController alloc] initWithActivityItems:@[] applicationActivities:nil];
        } break;
            
        case 2: {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"This is an alert" message:@"This is shown properly" preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewController];
            }]];
            return alert;
        } break;
            
        default:
            NSAssert(NO, @"Unhandled row: %d", (int)row);
            return nil;
    }
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
