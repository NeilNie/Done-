//
//  TipsViewController.h
//  Done!
//
//  Created by Yongyang Nie on 5/8/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EAIntroView.h>

BOOL intro;

@interface TipsViewController : UIViewController <EAIntroDelegate>

@property (weak, nonatomic) IBOutlet EAIntroView *introView;

@end