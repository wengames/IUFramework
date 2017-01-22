//
//  IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for IUChain.
FOUNDATION_EXPORT double IUChainVersionNumber;

//! Project version string for IUChain.
FOUNDATION_EXPORT const unsigned char IUChainVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <IUChain/PublicHeader.h>

#ifdef __OBJC__

// other class can add chain method if IUChainEnable is defined
#define IUChainEnable

#import "NSObject+IUChain.h"
    #import "UIView+IUChain.h"
        #import "UILabel+IUChain.h"
        #import "UIImageView+IUChain.h"
        #import "UIControl+IUChain.h"
            #import "UIButton+IUChain.h"
            #import "UITextField+IUChain.h"
        #import "UIScrollView+IUChain.h"
            #import "UITableView+IUChain.h"
            #import "UICollectionView+IUChain.h"
            #import "UITextView+IUChain.h"

#endif
