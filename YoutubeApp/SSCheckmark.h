//
//  Header.h
//  YoutubeApp
//
//  Created by Pranav Kasetti on 10/09/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM( NSUInteger, SSCheckMarkStyle )
{
    SSCheckMarkStyleOpenCircle,
    SSCheckMarkStyleGrayedOut
};

@interface SSCheckMark : UIView

@property (readwrite) bool checked;
@property (readwrite) SSCheckMarkStyle checkMarkStyle;

@end
