//
//  OCAppDelegate.m
//  OnionStorage
//
//  Created by Ben Gordon on 8/11/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCAppDelegate.h"
#import "OCViewController.h"
#import "OCSecurity.h"
#import "OCSession.h"
#import "Onion.h"

// Parse Constants
#import "ParseConstants.h"

// Parse Framework
#import <Parse/Parse.h>

@implementation OCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Set up Parse SDK
    [Onion registerSubclass];
    [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_CLIENT_ID];
    
    // Register for PRO purchase
    [PFPurchase addObserverForProduct:@"com.subvertllc.Onions.Pro" block:^(SKPaymentTransaction *transaction) {
        if (transaction) {
            if ([PFUser currentUser]) {
                [[PFUser currentUser] setValue:@YES forKey:@"Pro"];
                [[PFUser currentUser] setValue:transaction.transactionIdentifier forKey:@"ProReceipt"];
                [[PFUser currentUser] saveInBackground];
            }
        }
    }];
    
    // Set up ViewDeck
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:[[OCViewController alloc] initWithNibName:@"OCViewController" bundle:nil]];
    
    // Launch app
    self.window.rootViewController = self.mainNavigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (self.mainNavigationController) {
        if ([PFUser currentUser]) {
            [OCSession dropData];
            OCViewController *oVC = [[OCViewController alloc] initWithNibName:@"OCViewController" bundle:nil];
            [self.mainNavigationController setViewControllers:@[oVC]];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Go back to the login screen
    if (self.mainNavigationController) {
        if ([PFUser currentUser]) {
            [OCSession dropData];
            OCViewController *oVC = [[OCViewController alloc] initWithNibName:@"OCViewController" bundle:nil];
            [self.mainNavigationController setViewControllers:@[oVC]];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end