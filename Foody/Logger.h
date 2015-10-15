//
//  Logger.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#ifndef Logger_h
#define Logger_h

static inline void Log(NSString *format, ...) {
    __block va_list arg_list;
    va_start (arg_list, format);
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:arg_list];
    va_end(arg_list);
    NSLog(@"[Foody] %@", formattedString);
}

#ifdef _ERROR
#define Error(...) Log(__VA_ARGS__)
#else
#define Error(...)
#endif

//#ifdef _DEBUG
#define Debug(...) Log(__VA_ARGS__)
//#else
//#define Debug(...)
//#endif

#ifdef _MESSAGING_DEBUG
#define MessagingDebug(...) Log(__VA_ARGS__)
#else
#define MessagingDebug(...)
#endif

#endif
