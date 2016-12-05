//
//  EventTableViewCell.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSUILib/MDTableViewCell.h"
#import "Events.h"
#import <SWTableViewCell.h>

@interface EventTableViewCell : SWTableViewCell

@property (strong, nonatomic) Events *event;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *importantIcon;
@property (weak, nonatomic) IBOutlet UIImageView *AlertIcon;
@property (nonatomic, assign) id delegate;
- (IBAction)done:(id)sender;
- (void)setUpCell;

@end

@protocol EventCellDelegate <NSObject>

@required

-(void)clickedDone:(EventTableViewCell *)cell;

@end
