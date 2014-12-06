//
//  MainViewController.m
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "MainViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <AFNetworking/AFJSONRequestOperation.h>
#import "RESTAlertService.h"
#import "Location.h"
#import "SafetyScore.h"
#define SCREEN_HEIGHT_WITHOUT_STATUS_BAR     [[UIScreen mainScreen] bounds].size.height - 20
#define SCREEN_WIDTH                         [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_STATUS_BAR                    20
#define Y_DOWN_TABLEVIEW                     SCREEN_HEIGHT_WITHOUT_STATUS_BAR - 40
#define DEFAULT_HEIGHT_HEADER                200.0f
#define MIN_HEIGHT_HEADER                    10.0f
#define DEFAULT_Y_OFFSET                     ([[UIScreen mainScreen] bounds].size.height == 480.0f) ? -200.0f : -250.0f
#define FULL_Y_OFFSET                        -200.0f
#define MIN_Y_OFFSET_TO_REACH                -30
#define OPEN_SHUTTER_LATITUDE_MINUS          .005
#define CLOSE_SHUTTER_LATITUDE_MINUS         .018

#define BEARING 30
#define ZOOM 15.5
#define VIEWANGLE 45
//#define DISTANCE 1609.34
#define DISTANCE 500
@interface MainViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate>

@property (strong, nonatomic) UITableView *tblMain;
@property (strong, nonatomic) GMSMapView *mapView;
@property (nonatomic) float heighTableView;
@property (nonatomic) float heighTableViewHeader;
@property (nonatomic) float minHeighTableViewHeader;
@property (nonatomic) float minYOffsetToReach;
@property (nonatomic) float default_Y_mapView;
@property (nonatomic) float default_Y_tableView;
@property (nonatomic) float Y_tableViewOnBottom;
@property (nonatomic) float latitudeUserUp;
@property (nonatomic) float latitudeUserDown;
@property (nonatomic) BOOL  regionAnimated;
@property (nonatomic) BOOL  userLocationUpdateAnimated;

@property (strong, nonatomic) UITapGestureRecognizer  *tapMapViewGesture;
@property (strong, nonatomic) UITapGestureRecognizer  *tapTableViewGesture;
@property  (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *firstLocation;
@property (nonatomic) CGRect headerFrame;
@property (nonatomic) float headerYOffSet;
@property (nonatomic) BOOL isShutterOpen;
@property (nonatomic) BOOL displayMap;
@property (nonatomic) float heightMap;

@end

@implementation MainViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tblMain = [[UITableView alloc]  initWithFrame: CGRectMake(0, 20, SCREEN_WIDTH, self.heighTableView)];
    self.tblMain.tableHeaderView  = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.heighTableViewHeader)];
    [self.tblMain setBackgroundColor:[UIColor clearColor]];
    
    // Add gesture to gestures
    self.tapMapViewGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTapMapView:)];
    self.tapTableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTapTableView:)];
    self.tapTableViewGesture.delegate = self;
    [self.tblMain.tableHeaderView addGestureRecognizer:self.tapMapViewGesture];
    [self.tblMain addGestureRecognizer:self.tapTableViewGesture];
    
    // Init selt as default tableview's delegate & datasource
    self.tblMain.dataSource   = self;
    self.tblMain.delegate     = self;
    [self.view addSubview:self.tblMain];
    
    [self setupMapView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.mapView removeObserver:self forKeyPath:@"myLocation"];
}

// Set all view we will need
- (void)setup{
    _heighTableViewHeader       = DEFAULT_HEIGHT_HEADER;
    _heighTableView             = SCREEN_HEIGHT_WITHOUT_STATUS_BAR;
    _minHeighTableViewHeader    = MIN_HEIGHT_HEADER;
    _default_Y_tableView        = HEIGHT_STATUS_BAR;
    _Y_tableViewOnBottom        = Y_DOWN_TABLEVIEW;
    _minYOffsetToReach          = MIN_Y_OFFSET_TO_REACH;
    _latitudeUserUp             = CLOSE_SHUTTER_LATITUDE_MINUS;
    _latitudeUserDown           = OPEN_SHUTTER_LATITUDE_MINUS;
    _default_Y_mapView          = DEFAULT_Y_OFFSET;
    _headerYOffSet              = DEFAULT_Y_OFFSET;
    _heightMap                  = 1000.0f;
    _regionAnimated             = YES;
    _userLocationUpdateAnimated = YES;
}

- (void)setupMapView
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, self.default_Y_mapView, SCREEN_WIDTH, self.heighTableView)];
    self.mapView.settings.myLocationButton = YES;
    //self.mapView.settings.compassButton = YES;
    // Listen to the myLocation property of GMSMapView.
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.myLocationEnabled = YES;
    });
    self.mapView.delegate = self;
    [self.view insertSubview:self.mapView
                belowSubview: self.tblMain];
}

#pragma mark - Internal Methods

- (void)handleTapMapView:(UIGestureRecognizer *)gesture {
    if(!self.isShutterOpen){
        // Move the tableView down to let the map appear entirely
        [self openShutter];
    }
}

- (void)handleTapTableView:(UIGestureRecognizer *)gesture {
    if(self.isShutterOpen){
        // Move the tableView up to reach is origin position
        [self closeShutter];
    }
}

// Move DOWN the tableView to show the "entire" mapView
-(void) openShutter{
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.tblMain.tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.minHeighTableViewHeader)];
                         self.mapView.frame = CGRectMake(0, FULL_Y_OFFSET, self.mapView.frame.size.width, self.heightMap);
                         self.tblMain.frame = CGRectMake(0, self.Y_tableViewOnBottom, self.tblMain.frame.size.width, self.tblMain.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         // Disable cells selection
                         [self.tblMain setAllowsSelection:NO];
                         self.isShutterOpen = YES;
                         [self.tblMain setScrollEnabled:NO];
                         // Center the user 's location
                         //[self zoomToUserLocation:self.mapView.myLocation];
                     }];
}

// Move UP the tableView to get its original position
-(void) closeShutter{
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mapView.frame = CGRectMake(0, self.default_Y_mapView, self.mapView.frame.size.width, self.heighTableView);
                         self.tblMain.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.headerYOffSet, self.view.frame.size.width, self.heighTableViewHeader)];
                         self.tblMain.frame = CGRectMake(0, self.default_Y_tableView, self.tblMain.frame.size.width, self.tblMain.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         // Enable cells selection
                         [self.tblMain setAllowsSelection:YES];
                         self.isShutterOpen = NO;
                         [self.tblMain setScrollEnabled:YES];
                         [self.tblMain.tableHeaderView addGestureRecognizer:self.tapMapViewGesture];
                         // Center the user 's location
                         //[self zoomToUserLocation:self.mapView.myLocation];
                     }];
}

- (void)zoomToUserLocation:(CLLocation *)location{
    GMSCameraPosition *cam = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                         longitude:location.coordinate.longitude
                                                              zoom:ZOOM
                                                           bearing:BEARING viewingAngle:VIEWANGLE];
    [self.mapView animateToCameraPosition:cam];
}

#pragma mark - Table view Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset        = scrollView.contentOffset.y;
    CGRect headerMapViewFrame   = self.mapView.frame;
    
    if (scrollOffset < 0) {
        // Adjust map
        headerMapViewFrame.origin.y = self.headerYOffSet - ((scrollOffset / 2));
    } else {
        // Scrolling Up -> normal behavior
        headerMapViewFrame.origin.y = self.headerYOffSet - scrollOffset;
    }
    self.mapView.frame = headerMapViewFrame;
    
    // check if the Y offset is under the minus Y to reach
    if (self.tblMain.contentOffset.y < self.minYOffsetToReach){
        if(!self.displayMap)
            self.displayMap = YES;
    }else{
        if(self.displayMap)
            self.displayMap = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(self.displayMap)
        [self openShutter];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *identifier;
    if(indexPath.row == 0){
        identifier = @"firstCell";
        // Add some shadow to the first cell
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
            
            CGRect cellBounds       = cell.layer.bounds;
            CGRect shadowFrame      = CGRectMake(cellBounds.origin.x, cellBounds.origin.y, tableView.frame.size.width, 10.0);
            CGPathRef shadowPath    = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
            cell.layer.shadowPath   = shadowPath;
            [cell.layer setShadowOffset:CGSizeMake(-2, -2)];
            [cell.layer setShadowColor:[[UIColor grayColor] CGColor]];
            [cell.layer setShadowOpacity:.75];
        }
    }
    else{
        identifier = @"otherCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
    }
    [[cell textLabel] setText:@"Hello World !"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //first get total rows in that section by current indexPath.
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    
    //this is the last row in section.
    if(indexPath.row == totalRow - 1){
        // get total of cells's Height
        float cellsHeight = totalRow * cell.frame.size.height;
        // calculate tableView's Height with it's the header
        float tableHeight = (tableView.frame.size.height - tableView.tableHeaderView.frame.size.height);
        
        // Check if we need to create a foot to hide the backView (the map)
        if((cellsHeight - tableView.frame.origin.y)  < tableHeight){
            // Add a footer to hide the background
            int footerHeight = tableHeight - cellsHeight;
            tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, footerHeight)];
            [tableView.tableFooterView setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapTableViewGesture) {
        return _isShutterOpen;
    }
    return YES;
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:self.firstLocation.coordinate.latitude longitude:self.firstLocation.coordinate.longitude];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    if(distance >= DISTANCE || !self.firstLocation)
    {
        [self.mapView clear];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.geonames.org/findNearbyPostalCodesJSON?lat=%f&lng=%f&username=bugmenotuser", self.mapView.myLocation.coordinate.latitude, self.mapView.myLocation.coordinate.longitude]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"Geo Shit = %@", JSON);
            
            NSDictionary *dic = (NSDictionary *) JSON;
            if(dic != (NSDictionary *)[NSNull null])
            {
                if([dic objectForKey:@"postalCodes"] != [NSNull null])
                {
                    NSArray *zipCodeArray = [dic objectForKey:@"postalCodes"];
                    
//                    GMSMutablePath *poly = [GMSMutablePath path];
//                    //Add overlay
//                    for (NSDictionary *d in zipCodeArray)
//                    {
//                        float lat = 0;
//                        float lng = 0;
//                        if([d objectForKey:@"lat"] != [NSNull null])
//                        {
//                            NSString *s = (NSString *) [d objectForKey:@"lat"];
//                            lat = s.floatValue;
//                        }
//                    
//                        if([d objectForKey:@"lng"] != [NSNull null])
//                        {
//                            NSString *s = (NSString *) [d objectForKey:@"lng"];
//                            lng = s.floatValue;
//                        }
//                        [poly addCoordinate:CLLocationCoordinate2DMake(lat, lng)];
//                    }
//                    
//                    GMSPolygon *polygon = [GMSPolygon polygonWithPath:poly];
//                    polygon.fillColor = [UIColor colorWithRed:0 green:0.25 blue:0 alpha:0.3];
//                    polygon.strokeColor = [UIColor greenColor];
//                    polygon.strokeWidth = 5;
//                    polygon.map = self.mapView;
                    
                    NSDictionary *firstData = [zipCodeArray objectAtIndex:1];
                    
                    id<AlertService> service = [[RESTAlertService alloc]initWithObjectManager:[[AppDelegate delegate]mainObjectManager]];
                    
                    AlertsRequest *request = [AlertsRequest new];
                    NSString *zip = (NSString *)[firstData objectForKey:@"postalCode"];
                    request.zipCode = [zip integerValue];
                    
                    [service getAlertWithRequest:request withCompletion:^(RESTResponse *response, NSError *error) {
                        NSLog(@"Println: %@",response.result);
                        
                        //TODO: Parse data
                    }];
                    
                    [service getPin:[zip integerValue] withCompletion:^(RESTResponse *response, NSError *error) {
                        Location *loc = (Location *)response.result;
                        
                        GMSMarker *marker = [GMSMarker markerWithPosition:location.coordinate];
                        marker.title = loc.location;
//                        marker.snippet = [NSString stringWithFormat: @"Disaster: %@\nDrugs: %@\nViolence: %@\nFire: %@\nTraffic: %@\nOverall: %@\n", loc.safety.disaster, loc.safety.drugs, loc.safety.violence, loc.safety.fire, loc.safety.traffic, loc.safety.overall];
                        NSString *overall = @"0.0";
                        
                        if(loc.safety.overall != nil)
                            overall = loc.safety.overall;
                        
                        marker.snippet = [NSString stringWithFormat:@"Safety Score: %@", overall];
                        marker.infoWindowAnchor = CGPointMake(0.5, 0.5);
                        marker.map = self.mapView;
                        
                        [self.mapView setSelectedMarker:marker];
                        
                        GMSCameraPosition *cam = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                                             longitude:location.coordinate.longitude
                                                                                  zoom:ZOOM
                                                                               bearing:BEARING viewingAngle:VIEWANGLE];
                        [self.mapView animateToCameraPosition:cam];
                    }];
                }
            }

        } failure:nil];
        [operation start];
        
        
        
        self.firstLocation = location;
    }

    if(!self.firstLocation)
        self.firstLocation = location;
    
}

//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
//{
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, 0, 280, 40);
//    view.backgroundColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.4 alpha:1.0];
//    
//    return view;
//}

@end
