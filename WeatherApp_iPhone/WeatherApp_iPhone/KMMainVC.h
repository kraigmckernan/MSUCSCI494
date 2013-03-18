//
//  KMMainVC.h
//  WeatherApp_iPhone
//
//  Created by Kraig McKernan on 3/18/13.
//  Copyright (c) 2013 Kraig McKernan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMMainVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UILabel *midTempLabel;
    __weak IBOutlet UILabel *highTempLabel;
    __weak IBOutlet UILabel *lowTempLabel;
}

@end
