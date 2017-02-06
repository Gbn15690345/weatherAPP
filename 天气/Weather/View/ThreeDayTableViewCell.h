//
//  ThreeDayTableViewCell.h
//  天气
//
//  Created by  wyzc02 on 16/12/12.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeDayTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *firstDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstMaxdeLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoMaxdeLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeMaxdeLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstSunreisLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoSunreisLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeSunreisLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstSunsetLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoSunsetLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeSunsetLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstCondLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoCondLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeCondLabel;
@end
