//
//  SceneDelegate.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/14.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"



@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.

    // Save changes in the application's managed object context when the application transitions to the background.
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}

#pragma mark - 手动方式创建主框架
/*
#import "LiveStreamingViewController.h"
#import "NearByViewController.h"
#import "MessagesViewController.h"
#import "MyFollowViewController.h"
#import "MainPageViewController.h"
 */
/*
 - (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
        UIWindowScene *windowScene = (UIWindowScene *)scene;                           //手动创建窗口
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        self.window.frame = windowScene.coordinateSpace.bounds;
    
    
        UITabBarController *tabBarController = [[UITabBarController alloc] init];       //创建tabBar控制器
    
        LiveStreamingViewController *controller1 = [[LiveStreamingViewController alloc] init];  //创建5个子控制器
        NearByViewController *controller2 = [[NearByViewController alloc] init];
        MessagesViewController *controller3 = [[MessagesViewController alloc] init];
        MessagesViewController *controller4 = [[MessagesViewController alloc] init];
        MainPageViewController *controller5 = [[MainPageViewController alloc] init];
    
        controller1.view.backgroundColor = [UIColor systemGray6Color];
        controller1.tabBarItem.title = @"直播";
        controller1.tabBarItem.image = [UIImage imageNamed:@"video.png"];
    
        controller2.view.backgroundColor = [UIColor systemGray6Color];
        controller2.tabBarItem.title = @"附近";
        controller2.tabBarItem.image = [UIImage imageNamed:@"location.png"];
        controller2.tabBarItem.badgeValue = @"      ";
    //    controller2.tabBarItem.badgeColor = [UIColor blueColor];
    
        controller3.view.backgroundColor = [UIColor systemGray6Color];
        controller3.tabBarItem.title = @"消息";
        controller3.tabBarItem.image = [UIImage imageNamed:@"message_blue.png"];
        controller3.tabBarItem.badgeValue = @"6";
    
        controller4.view.backgroundColor = [UIColor systemGray6Color];
        controller4.tabBarItem.title = @"关注";
        controller4.tabBarItem.image = [UIImage imageNamed:@"heart_red.png"];
    
        controller5.view.backgroundColor = [UIColor systemGray6Color];
        controller5.tabBarItem.title = @"我的";
        controller5.tabBarItem.image = [UIImage imageNamed:@"me.png"];
    
        [tabBarController setViewControllers:@[controller1,controller2,controller3,controller4,controller5]];       //设置tabBar控制器的子控制器
    
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];    //设置navigation控制器的根控制器为tabbar控制器
    
        self.window.rootViewController = navigationController;      //设置窗口的根控制器为导航控制器
        [self.window makeKeyAndVisible];                            //设置为主窗口并可见
 }
*/

@end
