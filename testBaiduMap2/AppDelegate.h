//
//  AppDelegate.h
//  testBaiduMap2
//
//  Created by yyfwptz on 2017/5/4.
//  Copyright © 2017年 yyfwptz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    UIViewController *viewController;
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@end

