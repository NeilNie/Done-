//
//  NewEventViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <WatchConnectivity/WatchConnectivity.h>

#import "CustomCell.h"
#import "Events.h"
#import "EventsHelper.h"

@protocol CreateNewDelegate <NSObject>

-(void)addNewEventToProject:(Events *)event;
-(void)addProject:(Projects *)project;
@end

@interface CreateNewVC : UIViewController <WCSessionDelegate, UITableViewDelegate, UITableViewDataSource, CustomCellDelegates>{
    
    NSArray *array;
    NSMutableArray *cellDescriptors;
    NSMutableArray *visibleRowsPerSection;
    
    NSString *title;
    NSString *subTitle;
    NSDate *date;
    NSString *location;
    BOOL reminder;
}
@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) Projects *addedProject;
@property (strong, nonatomic) Events *addedEvent;
@property (nonatomic, assign) id <CreateNewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end