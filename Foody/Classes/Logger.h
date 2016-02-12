/*
 *  Copyright (c) 2015 Translation Exchange, Inc. All rights reserved.
 *
 *  _______                  _       _   _             ______          _
 * |__   __|                | |     | | (_)           |  ____|        | |
 *    | |_ __ __ _ _ __  ___| | __ _| |_ _  ___  _ __ | |__  __  _____| |__   __ _ _ __   __ _  ___
 *    | | '__/ _` | '_ \/ __| |/ _` | __| |/ _ \| '_ \|  __| \ \/ / __| '_ \ / _` | '_ \ / _` |/ _ \
 *    | | | | (_| | | | \__ \ | (_| | |_| | (_) | | | | |____ >  < (__| | | | (_| | | | | (_| |  __/
 *    |_|_|  \__,_|_| |_|___/_|\__,_|\__|_|\___/|_| |_|______/_/\_\___|_| |_|\__,_|_| |_|\__, |\___|
 *                                                                                        __/ |
 *                                                                                       |___/
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#ifndef AppLogger_h
#define AppLogger_h

#define AppLogLevelError 0
#define AppLogLevelWarning 1
#define AppLogLevelInfo 2
#define AppLogLevelDebug 3

typedef NSInteger AppLogLevel;

static inline void AppLog(AppLogLevel level, NSString *format, ...) {
    __block va_list arg_list;
    va_start (arg_list, format);
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:arg_list];
    va_end(arg_list);
    NSString *levelString = nil;
    switch (level) {
        case AppLogLevelError:
            levelString = @"Error";
            break;
        case AppLogLevelInfo:
            levelString = @"Info";
            break;
        case AppLogLevelWarning:
            levelString = @"Warning";
            break;
        case AppLogLevelDebug:
            levelString = @"Debug";
            break;
        default:
            levelString = @"Unknown";
            break;
    }
    NSLog(@"[App %@] %@", levelString, formattedString);
}

#if App_DEBUG >= AppLogLevelError
#define AppError(...) AppLog(AppLogLevelError, __VA_ARGS__)
#else
#define AppError(...)
#endif

#if App_DEBUG >= AppLogLevelWarning
#define AppWarn(...) AppLog(AppLogLevelWarning, __VA_ARGS__)
#else 
#define AppWarn(...)
#endif

#if App_DEBUG >= AppLogLevelInfo
#define AppInfo(...) AppLog(AppLogLevelInfo, __VA_ARGS__)
#else
#define AppInfo(...)
#endif

#if App_DEBUG >= AppLogLevelDebug
#define AppDebug(...) AppLog(AppLogLevelDebug, __VA_ARGS__)
#else
#define AppDebug(...)
#endif

#ifdef App_MESSAGING_DEBUG
#define MessagingDebug(...) AppLog(__VA_ARGS__)
#else
#define MessagingDebug(...)
#endif

#endif
