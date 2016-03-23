//
//  PTDownloadManager.h
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


#import <Foundation/Foundation.h>
#import "PTDownload.h"

#define kDownloadDidFinishLoading               @"kDownloadDidFinishLoading"
#define kDownloadDidFail                        @"kDownloadDidFail"
#define kDownloadDidReceiveData                 @"kDownloadDidReceiveData"
#define kDownloadDidFinishLoadingAllForManager  @"kDownloadDidFinishLoadingAllForManager"

@class PTDownloadManager;
@class PTDownload;

/** This delegate protocol informs the `delegate` regarding the success or failure of the downloads.
 *
 * @see DownloadManager
 * @see Download
 * @see delegate
 */

@interface PTDownloadManager : NSObject

//Singleton
+(instancetype)shareManager;

/// @name Control Download Manager

/** Add a download to the manager.
 *
 * @param filename
 *
 * The name of the local filename to where the file should be copied.
 *
 * @param url
 *
 * The remote URL of the source from where the file should be copied.
 *
 * @see filename
 * @see url
 */

- (void)addDownloadWithFilename:(NSString *)filename URL:(NSURL *)url item:(id)item;

/// Cancel all downloads in progress or pending.

- (void)cancelAll;

/// @name Properties

/** The maximum number of permissible number of concurrent downloads.
 * Many servers limit the number of concurrent downloads (4 or 6 are common)
 * and failure to observe this threshold will result in failures. Good
 * common practice is to set this to be 4.
 */

@property NSInteger maxConcurrentDownloads;

/** The array of `Download` objects representing the list of the ongoing or pending downloads.
 *
 * @see Download
 */

@property (nonatomic, strong) NSMutableArray *downloads;

/** The delegate object that this class notifies regarding the progress of the individual downloads.
 *
 * @see DownloadManagerDelegate
 */

@end
