//
//  GZCodeCoverageManager.m
//  GZCodeCoverageKit
//
//  Created by 葛高召 on 2023/11/8.
//

#import "GZCodeCoverageManager.h"

@implementation GZCodeCoverageManager

static GZCodeCoverageManager *shared = nil;

int __llvm_profile_runtime = 0;
void __llvm_profile_initialize_file(void);
const char *__llvm_profile_get_filename();
void __llvm_profile_set_filename(const char *);
int __llvm_profile_write_file();
int __llvm_profile_register_write_file_atexit(void);
const char *__llvm_profile_get_path_prefix();

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super allocWithZone:NULL] init];
    });
    return shared;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(enterBackGround)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
    }
    return self;
}


- (void)registerCoverage:(NSString *)buildid {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *targetName = [infoDictionary objectForKey:@"CFBundleExecutable"];
    NSLog(@"CFBundleExecutable: %@",targetName);
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"coverage_files/%@.profraw", targetName]];
    NSLog(@"filePath: %@", filePath);
    __llvm_profile_set_filename(filePath.UTF8String);
}

- (void)enterBackGround {
    __llvm_profile_write_file();
}

@end
