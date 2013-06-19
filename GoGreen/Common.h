//
//  Common.h
//  GoGreen
//
//  Created by admin mac on 11/17/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#ifndef GoGreen_Common_h
#define GoGreen_Common_h

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#endif
