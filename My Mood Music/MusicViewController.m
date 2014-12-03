//
//  MusicViewController.m
//  My Mood Music
//
//  Created by Kartik Sawant on 10/26/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import "MusicViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface MusicViewController ()

@end

@implementation MusicViewController
@synthesize playButton;
@synthesize audioPlayer;
NSString *tempC;
NSString *tempK;
NSString *c;
float speed;
float temp;
int num = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.location = [[CLLocation alloc] init];
    weatherManager = [[JFWeatherManager alloc]init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction:)];
    [self.temp addGestureRecognizer:tap];
    self.temp.userInteractionEnabled = YES;
    //[[AVAudioSession sharedInstance] setDelegate: self];
    NSError *myErr;
    
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        // Since there were no errors initializing the session, we'll allow begin receiving remote control events
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    //initialize our audio player
    //audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://www.cocoanetics.com/files/Cocoanetics_031.mp3"]];
    
    //[audioPlayer setShouldAutoplay:NO];
    //[audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
    //audioPlayer.view.hidden = YES;
    
    //[audioPlayer prepareToPlay];
    speed = self.location.speed*2.23693629;
    if(speed<0) {
        speed=0;
    }
    temp = 0;
    [weatherManager fetchWeatherDataForLatitude:40.431965 andLongitude:-86.918631 withAPIKeyOrNil:@"a4c33519650013f187bcdc2a48df7ead" :^(JFWeatherData *returnedWeatherData) {
        temp = [returnedWeatherData temperatureInUnitFormat:kTemperatureFarenheit];
        c = [returnedWeatherData currentConditionsTextualDescription];
        NSLog(@"%@",c);
        [self musicManager:self.locationManager];
            }];
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timeupdater) userInfo:nil repeats:YES];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

/*- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [player pause];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestAlwaysAuth{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString*title;
        title=(status == kCLAuthorizationStatusDenied) ? @"Location Services Are Off" : @"Background use is not enabled";
        NSString *message = @"Go to settings";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
        [alert show];
    }else if (status==kCLAuthorizationStatusNotDetermined)
    {[self.locationManager requestAlwaysAuthorization];}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingsURL];
    }
}

- (void)musicManager:(CLLocationManager *)manager {
    if(speed == 0 && num == 1) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                ////[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094591628-mx16l1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
        
    }
    else if(speed > 0 && speed <= 3 && num == 1) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"thunderstorm");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094591628-mx16l1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094782773-h99isx-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173344470/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094591628-mx16l1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 3 && speed <= 6.5 && num == 1) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094591628-mx16l1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173058369/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086741073-ibz2rp-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161089729/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"clouds");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/15996669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"extreme");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"rain");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000088433498-ux68fq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/163695063/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/15996669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096692120-um55tq-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176208183/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 6.5 && num == 1) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096312845-9kwh84-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175642077/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086464000-qf3oc1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160666084/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095053782-whizz1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/173752179/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086015340-83c3p4-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159966669/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089289879-ue4d7j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/165018741/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"additional");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed == 0 && num == 2) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                ////[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000082913710-i1vx6h-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/155226929/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"drizzle");
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164579150/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
        
    }
    else if(speed > 0 && speed <= 3 && num == 2) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000082913710-i1vx6h-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/155226929/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000086556965-8qo24q-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/160808486/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000082913710-i1vx6h-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/155226929/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 3 && speed <= 6.5 && num == 2) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000082913710-i1vx6h-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/155226929/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093004666-oa7t0g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/170727676/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096360456-hank0i-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175713002/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094363361-dnziu9-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172712345/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 6.5 && num == 2) {
        num++;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000081310850-05efx8-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/152589690/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000095917144-sv5h0n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175036938/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089316619-l710c5-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/157848233/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000094516150-98bsm1-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172942151/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096367948-b97kyh-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175724225/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed == 0 && num == 3) {
        num = 1;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                ////[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"hhttps://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"hhttps://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000085673471-db136n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159440665/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096119265-40g65d-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172138947/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161668677/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089711243-lyy02l-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162777996/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
        
    }
    else if(speed > 0 && speed <= 3 && num == 3) {
        num = 1;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000085673471-db136n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159440665/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"hhttps://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Classical"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096259545-6n7h4n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/175561037/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000085673471-db136n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159440665/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161668677/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"hhttps://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 3 && speed <= 6.5 && num == 3) {
        num = 1;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161668677/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"hhttps://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161668677/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Dubstep"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000085673471-db136n-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/159440665/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Country"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093245133-ph21ss-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/171086314/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161668677/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Punk"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000089257298-6brcul-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/164968734/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000082149579-lje63v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/150525686/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Soul"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000090999691-55yj4g-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/167701797/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    else if(speed > 6.5 && num == 3) {
        num = 1;
        if(temp < 40) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"hhttps://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161668677/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Reggae"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087346942-vf37ts-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162022719/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp >= 40 && temp <= 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161668677/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Rock"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"hhttps://i1.sndcdn.com/artworks-000090063383-byubi3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/166228488/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else if(temp > 80) {
            if((![c compare:@"Thunderstorm with Light Rain"]) || (![c compare:@"Thunderstorm with Rain"]) || (![c compare:@"Thunderstorm with Heavy Rain"]) || (![c compare:@"Light Thunderstorm"]) || (![c compare:@"Thunderstorm"]) || (![c compare:@"Heavy Thunderstorm"]) || (![c compare:@"Ragged Thunderstorm"]) || (![c compare:@"Thunderstorm with Light Drizzle"]) || (![c compare:@"Thunderstorm with Drizzle"]) || (![c compare:@"Thunderstorm with Heavy Drizzle"])) {
                self.genre.text = [NSString stringWithFormat:@"R&B"];
                NSLog(@"thunderstorm");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096604919-7gzl3v-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176078878/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Intensity Drizzle"]) || (![c compare:@"Drizzle"]) || (![c compare:@"Heavy Intensity Drizzle"]) || (![c compare:@"Light Intensity Drizzle Rain"]) || (![c compare:@"Shower Rain and Drizzle"]) || (![c compare:@"Heavy Shower Rain and Drizzle"]) || (![c compare:@"Shower Drizzle"]) || (![c compare:@"Drizzle Rain"]) || (![c compare:@"Heavy Intensity Drizzle Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"drizzle");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161668677/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Rain"]) || (![c compare:@"Moderate Rain"]) || (![c compare:@"Heavy Intensity Rain"]) || (![c compare:@"Very Heavy Rain"]) || (![c compare:@"Extreme Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Freezing Rain"]) || (![c compare:@"Shower Rain"]) || (![c compare:@"Light Intensity Shower Rain"]) || (![c compare:@"Heavy Intensity Shower Rain"]) || (![c compare:@"Ragged Shower Rain"])) {
                self.genre.text = [NSString stringWithFormat:@"Rap"];
                NSLog(@"rain");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087113859-89vwnm-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/161668677/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Light Snow"]) || (![c compare:@"Snow"]) || (![c compare:@"Heavy Snow"]) || (![c compare:@"Sleet"]) || (![c compare:@"Shower Sleet"]) || (![c compare:@"Light Rain and Snow"]) || (![c compare:@"Rain and Snow"]) || (![c compare:@"Light Shower Snow"]) || (![c compare:@"Shower Snow"]) || (![c compare:@"Heavy Shower Snow"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"snow");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Mist"]) || (![c compare:@"Smoke"]) || (![c compare:@"Haze"]) || (![c compare:@"Sand, Dust Whirls"]) || (![c compare:@"Fog"]) || (![c compare:@"Sand"]) || (![c compare:@"Dust"]) || (![c compare:@"Volcanic Ash"]) || (![c compare:@"Squalls"]) || (![c compare:@"Tornado"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"atmosphere");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Clear Sky"]) || (![c compare:@"Few Clouds"]) || (![c compare:@"Scattered Clouds"]) || (![c compare:@"Broken Clouds"]) || (![c compare:@"Overcast Clouds"]) || (![c compare:@"Sky Is Clear"])) {
                self.genre.text = [NSString stringWithFormat:@"Pop"];
                NSLog(@"clouds");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000093907678-79gb6j-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/172055891/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Tornado"]) || (![c compare:@"Tropical Storm"]) || (![c compare:@"Hurricane"]) || (![c compare:@"Cold"]) || (![c compare:@"Hot"]) || (![c compare:@"Windy"]) || (![c compare:@"Hail"])) {
                self.genre.text = [NSString stringWithFormat:@"Hip-Hop"];
                NSLog(@"extreme");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000087418675-ii50p3-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/162141701/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else if((![c compare:@"Calm"]) || (![c compare:@"Light Breeze"]) || (![c compare:@"Gentle Breeze"]) || (![c compare:@"Moderate Breeze"]) || (![c compare:@"Fresh Breeze"]) || (![c compare:@"Strong Breeze"]) || (![c compare:@"High Wind, Near Gale"]) || (![c compare:@"Gale"]) || (![c compare:@"Severe Gale"]) || (![c compare:@"Storm"]) || (![c compare:@"Violent Storm"]) || (![c compare:@"Hurricane"])) {
                self.genre.text = [NSString stringWithFormat:@"Metal"];
                NSLog(@"additional");
                self.albumart.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i1.sndcdn.com/artworks-000096690078-bauuot-large.jpg"]]];
                NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/tracks/176205207/stream?oauth_token=1-101815-119835817-98b12a635adfb"];
                playerItem = [AVPlayerItem playerItemWithURL:url];
                ((AppDelegate *)([UIApplication sharedApplication].delegate)).player = [AVPlayer playerWithPlayerItem:playerItem];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                //[player play];
            }
            else {
                NSLog(@"ERROR");
            }
        }
        else {
            NSLog(@"ERROR");
        }
    }
    [self setSlider];
}

- (IBAction)playButtonPress:(id)sender {
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
    //[player play];
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        //MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"AlbumArt"]];
        [songInfo setObject:@"Audio Title" forKey:@"Song Name" /*forKey:MPMediaItemPropertyTitle */];
        //[songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist];
        //[songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        //[songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage: self.albumart.image];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"hi", MPMediaItemPropertyTitle,
                                                             self.genre.text, MPMediaItemPropertyArtist, artwork, MPMediaItemPropertyArtwork,  1.0f, MPNowPlayingInfoPropertyPlaybackRate, nil];
}
- (void) timeupdater {
    CMTime duration = playerItem.duration;
    CMTime currentTime = playerItem.currentTime;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:CMTimeGetSeconds(duration)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSDate *date2 = [NSDate dateWithTimeIntervalSinceReferenceDate:CMTimeGetSeconds(currentTime)];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"mm:ss"];
    NSString *dateString2 = [formatter2 stringFromDate:date2];
    self.duration.text = [NSString stringWithFormat:@"%@",dateString];
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",dateString2];
    if(CMTimeGetSeconds(duration) == CMTimeGetSeconds(currentTime)) {
        [self musicManager:self.locationManager];
        //[player play];
        [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
    }
}


- (IBAction)pauseButtonPress:(id)sender {
    //[player pause];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).player pause];
}

- (void)resetSlider {
    self.currentTimeSlider.maximumValue = 1.0;
    self.currentTimeSlider.minimumValue = 0.0;
    [self.currentTimeSlider setValue:0.0];
}

- (IBAction)skipButtonPress:(id)sender {
    [self musicManager:self.locationManager];
   // [self resetSlider];
    //[player play];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        //MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"AlbumArt"]];
        [songInfo setObject:@"Audio Title" forKey:@"Song Name" /*forKey:MPMediaItemPropertyTitle */];
        //[songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist];
        //[songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        //[songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
    //[self setSlider];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage: self.albumart.image];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"hi", MPMediaItemPropertyTitle,
                                                             @"hello", MPMediaItemPropertyArtist, artwork, MPMediaItemPropertyArtwork,  1.0f, MPNowPlayingInfoPropertyPlaybackRate, nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    float x;
    x = self.location.speed*2.23693629;
    if(x<0) {
        x=0.000000;
    }
    speed = x;
    self.speed.text = [NSString stringWithFormat:@"Speed: %.2f MPH", x];
    [weatherManager fetchWeatherDataForLatitude:self.location.coordinate.latitude andLongitude:self.location.coordinate.longitude withAPIKeyOrNil:@"a4c33519650013f187bcdc2a48df7ead" :^(JFWeatherData *returnedWeatherData) {
        self.temp.text = [NSString stringWithFormat:@"Temperature: %.2f F",[returnedWeatherData temperatureInUnitFormat:kTemperatureFarenheit]];
        self.condition.text = [NSString stringWithFormat:@"Condition: %@",[returnedWeatherData currentConditionsTextualDescription]];
        tempC = [NSString stringWithFormat:@"Temperature: %.2f C",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]];
        tempK = [NSString stringWithFormat:@"Temperature: %.2f K",[returnedWeatherData temperatureInUnitFormat:kTemperatureKelvin]];
        temp = [returnedWeatherData temperatureInUnitFormat:kTemperatureFarenheit];
        c = [returnedWeatherData currentConditionsTextualDescription];
    }];
}

- (void)pushAction:(id)sender {
    self.temp.text = tempC;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction2:)];
    [self.temp addGestureRecognizer:tap];
    self.temp.userInteractionEnabled = YES;
}

- (void)pushAction2:(id)sender {
    self.temp.text = tempK;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction:)];
    [self.temp addGestureRecognizer:tap];
    self.temp.userInteractionEnabled = YES;
}

-(IBAction)sliding:(id)sender{
    
    CMTime newTime = CMTimeMakeWithSeconds(self.currentTimeSlider.value, 1);
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).player seekToTime:newTime];
}

-(void)setSlider{
    
    NSTimer *sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self    selector:@selector(updateSlider) userInfo:nil repeats:YES];
    self.currentTimeSlider.maximumValue = [self durationInSeconds];
    [self.currentTimeSlider addTarget:self action:@selector(sliding:) forControlEvents:UIControlEventValueChanged];
    self.currentTimeSlider.minimumValue = 0.0;
    self.currentTimeSlider.continuous = YES;
    [self updateSlider];
}

- (void)updateSlider {
    self.currentTimeSlider.maximumValue = [self durationInSeconds];
    self.currentTimeSlider.value = [self currentTimeInSeconds];
}

- (Float64)durationInSeconds {
    Float64 dur;
    if(CMTimeGetSeconds(playerItem.duration) < 10) {
        dur = CMTimeGetSeconds(playerItem.duration);
    }
    else {
        dur = 240;
    }
    /*Float64 dur = 240;
    NSLog(@"%f",CMTimeGetSeconds(playerItem.duration));*/
    return dur;
}


- (Float64)currentTimeInSeconds {
    Float64 dur = CMTimeGetSeconds(playerItem.currentTime);
    return dur;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)theEvent
{
    if (theEvent.type == UIEventTypeRemoteControl)
    {
        switch(theEvent.subtype) {
            //case UIEventSubtypeRemoteControlTogglePlayPause:
                //Insert code
                
            case UIEventSubtypeRemoteControlPlay:
                [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [((AppDelegate *)([UIApplication sharedApplication].delegate)).player pause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self musicManager:self.locationManager];
                [((AppDelegate *)([UIApplication sharedApplication].delegate)).player play];
                MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage: self.albumart.image];
                [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"hi", MPMediaItemPropertyTitle,
                                                                         @"hello", MPMediaItemPropertyArtist, artwork, MPMediaItemPropertyArtwork,  1.0f, MPNowPlayingInfoPropertyPlaybackRate, nil];
                break;
            //default:
                //return;
        }
    }
}

@end
