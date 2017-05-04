//
//  ViewController.m
//  testBaiduMap2
//
//  Created by yyfwptz on 2017/5/4.
//  Copyright © 2017年 yyfwptz. All rights reserved.
//

#import "ViewController.h"
#import "BMKClusterManager.h"


@interface ClusterAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, assign) NSInteger size;

@end

@implementation ClusterAnnotation

@synthesize size = _size;

@end


@interface ClusterAnnotationView : BMKPinAnnotationView {

}

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ClusterAnnotationView

@synthesize size = _size;
@synthesize label = _label;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:11];
        _label.textAlignment = NSTextAlignmentCenter;
        /**
         * 圆形
         */
        _label.layer.cornerRadius = _label.bounds.size.width/2;
        _label.layer.masksToBounds = YES;
        [self addSubview:_label];
        self.alpha = 0.85;
    }
    return self;
}

- (void)setSize:(NSInteger)size {
    _size = size;
    if (_size == 1) {
        self.label.hidden = YES;
        self.pinColor = BMKPinAnnotationColorRed;
        return;
    }
    self.label.hidden = NO;
    if (size > 20) {
        self.label.backgroundColor = [UIColor purpleColor];
    } else if (size > 10) {
        self.label.backgroundColor = [UIColor purpleColor];
    } else if (size > 5) {
        self.label.backgroundColor = [UIColor purpleColor];
    } else {
        self.label.backgroundColor = [UIColor purpleColor];
    }
    _label.text = [NSString stringWithFormat:@"%ld", size];
}

@end

@interface ViewController (){
    BMKClusterManager *_clusterManager;
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _locService = [[BMKLocationService alloc]init];

    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }

    _clusterManager = [[BMKClusterManager alloc] init];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = _mapView;

    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeHeading;
    _mapView.showsUserLocation = YES;

    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(43.976765990111566, 125.39304679529695);

    //向点聚合管理类中添加标注
    for (NSInteger i = 0; i < 20; i++) {
        double lat =  (arc4random() % 100) * 0.001f;
        double lon =  (arc4random() % 100) * 0.001f;
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        clusterItem.coor = CLLocationCoordinate2DMake(coor.latitude + lat, coor.longitude + lon);
        [_clusterManager addClusterItem:clusterItem];
    }
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"ClusterMark";
    ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
    ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    annotationView.size = cluster.size;
    annotationView.draggable = YES;
    annotationView.annotation = cluster;
    return annotationView;

}


- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    [self performSelector:@selector(setIcon)];
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 44;
    coor.longitude = 125.40;
    annotation.coordinate = coor;
    [_mapView addAnnotation:annotation];
}

- (void) viewDidAppear:(BOOL)animated {

}

//-(void)setIcon {
//    /**
//     * 测试数据
//     */
//    _latitude = @[@"43.976765990111566", @"43.98045709845306", @"43.980379256725655", @"43.97433323526407", @"43.981890665224014"];
//    _longitude = @[@"125.39304679529695", @"125.39393611775184", @"125.38560882567434", @"125.38875289495925", @"125.39140289621369"];
//    _icon = [NSMutableArray arrayWithCapacity:[_latitude count]];
//    for (NSUInteger j = 0; j < [_latitude count]; ++j) {
//        annotation = [[BMKPointAnnotation alloc]init];
//        CLLocationCoordinate2D clLocationCoordinate2D;
//        clLocationCoordinate2D.latitude = [_latitude[j] doubleValue];
//        clLocationCoordinate2D.longitude = [_longitude[j] doubleValue];
//        [_icon addObject:[NSValue value:&clLocationCoordinate2D withObjCType:@encode(CLLocationCoordinate2D)]];
//        annotation.coordinate = clLocationCoordinate2D;
//        [_mapView addAnnotation:annotation];
//    }
//}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    if ([view isKindOfClass:[ClusterAnnotationView class]]) {
        ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
        if (clusterAnnotation.size > 1) {
            [mapView setCenterCoordinate:view.annotation.coordinate];
            [mapView zoomIn];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;

}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];

}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    /**
     * 跳转 放大
     */
    _mapView.centerCoordinate = userLocation.location.coordinate;
    [_mapView setZoomLevel:17];

}

- (void)didStopLocatingUser
{
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
}


//更新聚合状态
- (void)updateClusters {
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = _clusterCaches[_clusterZoom - 3];

        if (clusters.count > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{

                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];

                dispatch_async(dispatch_get_main_queue(), ^{
                    for (BMKCluster *item in array) {
                        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
                        [clusters addObject:annotation];
                    }
                    [_mapView removeAnnotations:_mapView.annotations];
                    [_mapView addAnnotations:clusters];
                });
            });
        }
    }
}

- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel) {
        [self updateClusters];
    }
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self updateClusters];
}

@end
