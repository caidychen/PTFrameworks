//
//  PTDownloadManager.m
//
//  Created by CHEN KAIDI on 15/3/2016.
//  Copyright © 2016 Putao. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PTDownloadManager.h"
#import "PTDownload.h"

@interface PTDownloadManager () <DownloadDelegate>

@property (nonatomic) BOOL cancelAllInProgress;

@end

@implementation PTDownloadManager

#pragma mark - DownloadManager public methods

+(instancetype)shareManager{
    static PTDownloadManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PTDownloadManager alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _downloads = [[NSMutableArray alloc] init];
        _maxConcurrentDownloads = 4;
    }
    
    return self;
}

- (void)addDownloadWithFilename:(NSString *)filename URL:(NSURL *)url item:(id)item
{
    PTDownload *download = [[PTDownload alloc] initWithFilename:filename URL:url delegate:self];
    download.item = item;
    [self.downloads addObject:download];
    
    [self start];
}

- (void)start
{
    [self tryDownloading];
}

- (void)cancelAll
{
    self.cancelAllInProgress = YES;
    
    while ([self.downloads count] > 0) {
        [[self.downloads objectAtIndex:0] cancel];
    }
    
    self.cancelAllInProgress = NO;
    
    [self informDelegateThatDownloadsAreDone];
}

#pragma mark - DownloadDelegate Methods

- (void)downloadDidFinishLoading:(PTDownload *)download
{
    [self.downloads removeObject:download];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadDidFinishLoading object:download];
    [self tryDownloading];
}

- (void)downloadDidFail:(PTDownload *)download
{
    [self.downloads removeObject:download];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadDidFail object:download];
    if (!self.cancelAllInProgress) {
        [self tryDownloading];
    }
}

- (void)downloadDidReceiveData:(PTDownload *)download
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadDidReceiveData object:download];
}

#pragma mark - Private methods

- (void)informDelegateThatDownloadsAreDone
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadDidFinishLoadingAllForManager object:nil];
}

- (void)tryDownloading
{
    NSInteger totalDownloads = [self.downloads count];
    
    // if we're done, inform the delegate
    
    if (totalDownloads == 0) {
        [self informDelegateThatDownloadsAreDone];
        return;
    }
    
    // while there are downloads waiting to be started and we haven't hit the maxConcurrentDownloads, then start
    
    while ([self countUnstartedDownloads] > 0 && [self countActiveDownloads] < self.maxConcurrentDownloads) {
        for (PTDownload *download in self.downloads) {
            if (!download.isDownloading) {
                [download start];
                break;
            }
        }
    }
}

- (NSInteger)countUnstartedDownloads
{
    return [self.downloads count] - [self countActiveDownloads];
}

- (NSInteger)countActiveDownloads
{
    NSInteger activeDownloadCount = 0;
    
    for (PTDownload *download in self.downloads) {
        if (download.isDownloading)
            activeDownloadCount++;
    }
    
    return activeDownloadCount;
}

@end
