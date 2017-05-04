//
//  ViewController.h
//  testBaiduMap2
//
//  Created by yyfwptz on 2017/5/4.
//  Copyright © 2017年 yyfwptz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>


@interface ViewController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate> {
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    ViewController *_viewController;
    NSArray *_latitude;
    NSArray *_longitude;
    NSMutableArray *_icon;
    BMKPointAnnotation* annotation;

}

@end

