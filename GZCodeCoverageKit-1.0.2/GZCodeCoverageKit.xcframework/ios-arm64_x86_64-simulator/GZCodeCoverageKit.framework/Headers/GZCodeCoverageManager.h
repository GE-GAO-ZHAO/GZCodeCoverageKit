//
//  GZCodeCoverageManager.h
//  GZCodeCoverageKit
//
//  Created by 葛高召 on 2023/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GZCodeCoverageManager : NSObject

+ (instancetype)shared;
- (void)registerCoverage:(NSString *)buildid;


@end

NS_ASSUME_NONNULL_END
