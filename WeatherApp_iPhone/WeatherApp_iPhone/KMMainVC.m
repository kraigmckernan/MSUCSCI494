//
//  KMMainVC.m
//  WeatherApp_iPhone
//
//  Created by Kraig McKernan on 3/18/13.
//  Copyright (c) 2013 Kraig McKernan. All rights reserved.
//

#import "KMMainVC.h"
#import "KMCollectionCell.h"
#import "KMWeather.h"

@interface KMMainVC ()

@end

@implementation KMMainVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *sun = [UIImage imageNamed:@"sun.jpg"];
    [imageView setImage:sun];
    [dateLabel setText:@"Today"];
    [midTempLabel setText:@"-1*F"];
    [lowTempLabel setText:@"-1"];
    [highTempLabel setText:@"-1"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherRefreshed:) name:@"weatherRefreshed" object:nil];
    weather = [[KMWeather alloc] init];

    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [weather numData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    int multiplierTemp = indexPath.row*2;
    NSDate *date = [NSDate dateWithTimeInterval:21600*multiplierTemp sinceDate:startDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *string;
    if ((multiplierTemp%4)==0) {
        string = [NSString stringWithFormat:@"ccc 'Day'"];
    } else {
        string = [NSString stringWithFormat:@"ccc 'Night'"];
    }
    [dateFormatter setDateFormat:string];
    
    KMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setBounds:CGRectMake(0, 0, 100, 100)];
    [cell setBackgroundColor:[UIColor grayColor]];
    [cell setWeather:[NSNumber numberWithInt:[weather weatherForDate:date]]];
    
    [cell setText:[dateFormatter stringFromDate:[NSDate dateWithTimeInterval:(60*60*-7) sinceDate:date]]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    multiplier = indexPath.row*2;
    
    [self setWeatherValues];
}

-(void)weatherRefreshed:(NSNotification*)note {
    
    if (DEBUG) {
        
        /*NSLog(@"now: %f", [weather lowTemp]);
        NSLog(@"nowish: %f", [weather lowForDate:[weather currentDate]]);
        NSLog(@"in 6: %f", [weather lowForDate:[NSDate dateWithTimeInterval:21600 sinceDate:[weather currentDate]]]);*/
    }
        
    
    
    [self setCollectionValues];
    
    startDate = [weather currentDate];
    
    multiplier = 0;
    [self setWeatherValues];
}

-(void)setCollectionValues {
    [collectionV reloadData];
}

-(void)setWeatherValues {
    
    NSDate *tempDate = [NSDate dateWithTimeInterval:21600*multiplier sinceDate:startDate];
    
    [midTempLabel setText:[NSString stringWithFormat:@"%3.0f*F", [weather tempForDate:tempDate]]];
    [lowTempLabel setText:[NSString stringWithFormat:@"%2.0f", [weather lowForDate:tempDate]]];
    [highTempLabel setText:[NSString stringWithFormat:@"%2.0f", [weather highForDate:tempDate]]];
    
    
    if ([weather snowForDate:tempDate] > .5) { //clean this up
        [imageView setImage:[UIImage imageNamed:@"snow"]];
    } else if ([weather rainForDate:tempDate] > .5) {
        [imageView setImage:[UIImage imageNamed:@"raining"]];
    } else if ([weather cloudsForDate:tempDate] > .66) {
        [imageView setImage:[UIImage imageNamed:@"cloudy"]];
    } else if ([weather cloudsForDate:tempDate] > .33) {
        [imageView setImage:[UIImage imageNamed:@"partlycloudy"]];
    } else if (multiplier%4==2) {
        [imageView setImage:[UIImage imageNamed:@"night"]];
    } else {
        [imageView setImage:[UIImage imageNamed:@"sunny"]];
    }
    
    precipLabel.text = [NSString stringWithFormat:@"%.2f",[weather precipForDate:tempDate]];
    
    tempDate = [NSDate dateWithTimeInterval:(60*60*-7) sinceDate:tempDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd 'at' HH:00"];
    NSString *dispDate = [dateFormatter stringFromDate:tempDate];
    dateLabel.text = dispDate;

    
}

@end
