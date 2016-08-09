//
//  NewEventViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "CreateNewVC.h"

@interface CreateNewVC ()

@end

@implementation CreateNewVC

@synthesize delegate;

- (IBAction)addEvent:(id)sender {
    
    if ([self checkData] == NO) {
        [RKDropdownAlert title:@"Opps" message:@"You have to set a date and a title for your project/event."];
        
    }else{
        
        if (reminder == [NSNumber numberWithBool:YES]) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = date;
            notification.alertTitle = NSLocalizedString(@"You have a new reminder", nil);
            notification.alertBody = title;
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.timeZone = [NSTimeZone localTimeZone];
            notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        if (self.addedToProject != nil){
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            Events *event = [EventsHelper createEventWithDate:date title:title otherInfo:nil];
            event.important = important.boolValue;
            [self.addedToProject.events addObject:event];
            [realm commitWriteTransaction];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [RKDropdownAlert title:@"Opps" message:@"You have to select a project that this event will be added to."];
        }
        [self syncWithWatch];
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM/yyyy HH:MM";
    }
    return dateFormatter;
}

-(void)syncWithWatch{
    
    NSLog(@"sent request");
    WCSession *session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    [session updateApplicationContext:@{@"needSync": @"YES"} error:nil];
    NSLog(@"updated context");
}

-(BOOL)checkData{
    
    if (title != nil && date != nil) {
        return YES;
    }else{
        return NO;
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableArray *)getPickerViewData{
    
    RLMResults *result = [Projects allObjects];
    NSMutableArray *Rarray = [NSMutableArray array];
    
    for (int i = 0; i < result.count; i ++) {
        Projects *project = [result objectAtIndex:i];
        [Rarray addObject:project.title];
    }
    if (result.count == 0) {
        [Rarray addObject:@"No Project"];
    }
    return Rarray;
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            return 55;
            break;
        case 1:
            return 300;
            break;
        case 2:
            return 55;
            break;
        case 3:
            return 55;
            break;
        case 4:
            return 130;
            break;
            
        default:
            return 60;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CustomCell *cell = [[CustomCell alloc] init];
    
    if (indexPath.row == 0) {
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellTextfield" forIndexPath:indexPath];
        cell.textField.floatingLabel = YES;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.row == 1){
        TimelineTableViewCell *cell = (TimelineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idTimelineCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.row == 2){
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellSwitch" forIndexPath:indexPath];
        cell.SwitchLabel.text = NSLocalizedString(@"Reminder", nil);
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.row == 3){
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellSwitch" forIndexPath:indexPath];
        cell.SwitchLabel.text = NSLocalizedString(@"Important", nil);
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.row == 4){
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"idValuePicker" forIndexPath:indexPath];
        cell.pickerViewData = [self getPickerViewData];
        cell.delegate = self;
        return cell;
        
    }else{
        return cell;
    }
}

#pragma mark - CustomCell Delegate

-(void)dateWasSelected:(NSDate *)selectedDate{
    
    date = selectedDate;
}

-(void)textFieldChanged:(NSString *)newText withCell:(CustomCell *)parentCell{

    title = newText;
    [self.table reloadData];
}

-(void)switchHasChanged:(BOOL)isOn atCell:(CustomCell *)cell{
    
    NSIndexPath *index = [self.table indexPathForCell:cell];
    if (index.row == 2) {
        reminder = [NSNumber numberWithBool:YES];
    }else{
        important = [NSNumber numberWithBool:YES];
    }
}

-(void)pickerViewValueSelected:(NSString *)string{
    self.addedToProject = [EventsHelper findProjectWithName:string];
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{

    self.table.hidden = NO;
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.table registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"idCellTextfield"];
    [self.table registerNib:[UINib nibWithNibName:@"DatePickerCell" bundle:nil] forCellReuseIdentifier:@"idCellDatePicker"];
    [self.table registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"idCellSwitch"];
    [self.table registerNib:[UINib nibWithNibName:@"ValuePickerCell" bundle:nil] forCellReuseIdentifier:@"idValuePicker"];
    [self.table registerNib:[UINib nibWithNibName:@"TimelineTableViewCell" bundle:nil] forCellReuseIdentifier:@"idTimelineCell"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
