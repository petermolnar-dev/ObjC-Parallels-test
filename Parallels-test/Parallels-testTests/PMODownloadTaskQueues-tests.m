//
//  PMODownloadTaskQueues-tests.m
//  Parallels-test
//
//  Created by Peter Molnar on 13/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMODownloadTaskQueues.h"

@interface PMODownloadTaskQueues_tests : XCTestCase
@property (strong, nonatomic) PMODownloadTaskQueues *queues;

@end


@implementation PMODownloadTaskQueues_tests

- (void)setUp {
    [super setUp];
    if (!_queues) {
        _queues = [[PMODownloadTaskQueues alloc] init];
    }
}

- (void)tearDown {
    [super tearDown];
    _queues = nil;
}

#pragma mark - Acessors
-(PMODownloadTaskQueues *)queues {
    if (!_queues) {
        _queues = [[PMODownloadTaskQueues alloc] init];
    }
    return _queues;
}

#pragma mark - Helper functions
-(NSURLSessionTask *)newSmallDownloadTask {
    return [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://i2.wp.com/petermolnar.hu/wp-content/uploads/2014/04/pm_cv-2015_preview.png"]];
}

-(NSURLSessionTask *)newBigDownloadTask {
    return [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://93.175.29.76/web/wwdc/wwdc5.png"]];;
}


#pragma mark - Tests
-(void)testAddTaskToNormalQueue {
    // Add a task1 to normal queue
    // - task1 is running
    // - task1 is in default priority
    NSURLSessionTask *normalPriorityDownloadTask = [self newSmallDownloadTask];
    [self.queues addDownloadTaskToNormalPriorityQueue:normalPriorityDownloadTask];
    BOOL isRunning = normalPriorityDownloadTask.state == NSURLSessionTaskStateRunning;
    BOOL isDefaultPriority = normalPriorityDownloadTask.priority == NSURLSessionTaskPriorityDefault;
    [normalPriorityDownloadTask suspend];
    XCTAssertTrue(self.queues.normalQueueTaskCount == 1 && isRunning && isDefaultPriority);
}

-(void)testAddTaskToPriorityQueue {
    // Add a task1 to priority queue
    // - task1 is running
    // - task1 is in high priority
    NSURLSessionTask *highPriorityDownloadTask = [self newSmallDownloadTask];
    
    [self.queues addDownloadTaskToHighPriorityQueue:highPriorityDownloadTask];
    BOOL isRunning = highPriorityDownloadTask.state == NSURLSessionTaskStateRunning;
    [highPriorityDownloadTask suspend];
    BOOL isHighPriority = highPriorityDownloadTask.priority == NSURLSessionTaskPriorityHigh;
    XCTAssertTrue(self.queues.priorityQueueTaskCount == 1 && isRunning && isHighPriority);
    
}


- (void)testTryToAddSameTaskToNormalPriorityQueue {
    // Task1 and task2 trying to download the same url
    // Add task1 normal priority queue
    //  - Task1 needs to be running
    // Add task2 to normal priority queue
    //  - Task1 needs to be running after adding
    //  - Only 1 task should be in the normal priority queue
    NSURLSessionTask *normalDownloadTask = [self newSmallDownloadTask];
    NSURLSessionTask *downloadTaskWithSameURL = [self newSmallDownloadTask];

    [self.queues addDownloadTaskToNormalPriorityQueue:normalDownloadTask];
    BOOL isRunningFirst = normalDownloadTask.state == NSURLSessionTaskStateRunning;
    [normalDownloadTask suspend];

    [self.queues addDownloadTaskToNormalPriorityQueue:downloadTaskWithSameURL];
    BOOL isRunningAgainAfterAdd = normalDownloadTask.state == NSURLSessionTaskStateRunning;
    [downloadTaskWithSameURL suspend];
    
    XCTAssertTrue(self.queues.normalQueueTaskCount == 1 && isRunningFirst && isRunningAgainAfterAdd);
}

- (void)testTryToAddRunningNormalTaskToHighPriorityQueue {
    // Add task1 to normal queue, than add task2 with same url to priority queue
    // - Task1 needs to be running
    // - Only one task in priority queue, 0 task in normal queue
    // - task1 is in highPriority
    NSURLSessionTask *normalPriorityDownloadTask = [self newSmallDownloadTask];
    NSURLSessionTask *downloadTaskWithSameURL = [self newSmallDownloadTask];
    
    [self.queues addDownloadTaskToHighPriorityQueue:normalPriorityDownloadTask];
    BOOL isRunning = normalPriorityDownloadTask.state == NSURLSessionTaskStateRunning;
    [normalPriorityDownloadTask suspend];
    
    [self.queues addDownloadTaskToHighPriorityQueue:downloadTaskWithSameURL];
    BOOL isRunnigInHighPriorityQueue = normalPriorityDownloadTask.state == NSURLSessionTaskStateRunning;
    [downloadTaskWithSameURL suspend];
    BOOL isHighPriority = normalPriorityDownloadTask.priority == NSURLSessionTaskPriorityHigh;
    XCTAssertTrue(self.queues.priorityQueueTaskCount == 1 && self.queues.normalQueueTaskCount == 0 && isRunning && isRunnigInHighPriorityQueue && isHighPriority);
}

- (void)testAddNewTasktoHighPriorityWhileNormalIsRunnig {
    NSURLSessionTask *normalPriorityDownloadTask = [self newSmallDownloadTask];
    NSURLSessionTask *highPriorityNormalTask = [self newBigDownloadTask];
    
    [self.queues addDownloadTaskToNormalPriorityQueue:normalPriorityDownloadTask];
    BOOL isFirstRunning = normalPriorityDownloadTask.state == NSURLSessionTaskStateRunning;

    [self.queues addDownloadTaskToHighPriorityQueue:highPriorityNormalTask];
    BOOL isFirstSuspendedAfterAdd = normalPriorityDownloadTask.state == NSURLSessionTaskStateSuspended;
    BOOL isPriorityRunnig = highPriorityNormalTask.state == NSURLSessionTaskStateRunning;
    
    XCTAssertTrue(self.queues.priorityQueueTaskCount == 1 && self.queues.normalQueueTaskCount == 1 && isFirstRunning && isPriorityRunnig && isFirstSuspendedAfterAdd);
}

- (void)testRemoveTaskFromNormalQueue {
    NSURLSessionTask *normalPriorityDownloadTask = [self newSmallDownloadTask];
    [self.queues addDownloadTaskToNormalPriorityQueue:normalPriorityDownloadTask];
    [normalPriorityDownloadTask suspend];
    [self.queues removeDownloadTaskFromAllQueues:normalPriorityDownloadTask];
    
    XCTAssertTrue([self.queues normalQueueTaskCount]==0);
    
}


- (void)testRemoveTaskFromPriorityQueue {
    NSURLSessionTask *highPriorityDownloadTask = [self newSmallDownloadTask];
    
    [self.queues addDownloadTaskToHighPriorityQueue:highPriorityDownloadTask];
    [highPriorityDownloadTask suspend];
    [self.queues removeDownloadTaskFromAllQueues:highPriorityDownloadTask];
    
    XCTAssertTrue(self.queues.priorityQueueTaskCount == 0);

    
}

- (void)testMoveTaskFromNormalToPriorityQueue {
    NSURLSessionTask *taskForChangingPrioirities = [self newSmallDownloadTask];
    
    [self.queues addDownloadTaskToNormalPriorityQueue:taskForChangingPrioirities];
    [taskForChangingPrioirities suspend];
    [self.queues changeDownloadTaskToHighPriorityQueueFromURL:taskForChangingPrioirities.currentRequest.URL];
    BOOL isRunning = taskForChangingPrioirities.state == NSURLSessionTaskStateRunning;
    [taskForChangingPrioirities suspend];
    XCTAssertTrue(self.queues.priorityQueueTaskCount == 1 && isRunning && taskForChangingPrioirities.priority == NSURLSessionTaskPriorityHigh );
    
}

- (void)testMoveTaskFromPriorityToNormalQueue {
    NSURLSessionTask *taskForChangingPrioirities = [self newSmallDownloadTask];
    
    [self.queues addDownloadTaskToHighPriorityQueue:taskForChangingPrioirities];
    [taskForChangingPrioirities suspend];

    [self.queues changeDownloadTaskToNormalPriorityQueueFromURL:taskForChangingPrioirities.currentRequest.URL];
    BOOL isRunning = taskForChangingPrioirities.state == NSURLSessionTaskStateRunning;
    [taskForChangingPrioirities suspend];
    
    XCTAssertTrue(self.queues.normalQueueTaskCount == 1 && isRunning && taskForChangingPrioirities.priority == NSURLSessionTaskPriorityDefault );
    
}


- (void)testMoveTaskToPriorityWithSuspendingNormalQueue {
    // Adding 2 tasks (task1, task2) to normal priority queue,
    //  - both tasks need to be running.
    // Move task2 to high priority:
    //  - task1 needs to be suspended
    //  - task2 needs to be running
    //  - task2 needs to be in high priority
    NSURLSessionTask *normalPriorityDownloadTask = [self newSmallDownloadTask];
    NSURLSessionTask *highPriorityNormalTask = [self newBigDownloadTask];
    
    [self.queues addDownloadTaskToNormalPriorityQueue:normalPriorityDownloadTask];
    BOOL isFirstRunning = normalPriorityDownloadTask.state == NSURLSessionTaskStateRunning;
    [self.queues addDownloadTaskToNormalPriorityQueue:highPriorityNormalTask];
    BOOL isSecondRunning = highPriorityNormalTask.state == NSURLSessionTaskStateRunning;
    [self.queues changeDownloadTaskToHighPriorityQueueFromURL:highPriorityNormalTask.currentRequest.URL];
    BOOL isPriorityRunnig = highPriorityNormalTask.state == NSURLSessionTaskStateRunning;
    BOOL isNormalSuspended = normalPriorityDownloadTask.state == NSURLSessionTaskStateSuspended;
    BOOL isHighPriority = highPriorityNormalTask.priority == NSURLSessionTaskPriorityHigh;
    
    XCTAssertTrue(self.queues.priorityQueueTaskCount == 1 && self.queues.normalQueueTaskCount == 1 && isFirstRunning && isSecondRunning && isNormalSuspended && isPriorityRunnig && isHighPriority);
    
}

- (void)testMoveTaskToNormalWithResumingNormalQueue {
    // Add a task (task1) to high priority, another one (task2) to normal priority.
    //   - task1 should be running, and high Priority
    //   - task2 should be suspended
    // change task1 back to normal priority.
    //  - task1 should be running
    //  - task2 should be runnig
    //  - task1 should be normal priority
    //  - highPriorityQueue should be empty
    NSURLSessionTask *normalPriorityDownloadTask = [self newSmallDownloadTask];
    NSURLSessionTask *highPriorityNormalTask = [self newBigDownloadTask];
    
    [self.queues addDownloadTaskToNormalPriorityQueue:highPriorityNormalTask];
    BOOL isHighPriorityRunning = highPriorityNormalTask.state == NSURLSessionTaskStateRunning;
    [highPriorityNormalTask suspend];
    
    [self.queues addDownloadTaskToNormalPriorityQueue:normalPriorityDownloadTask];
    BOOL isNormalIsSuspended = normalPriorityDownloadTask.state == NSURLSessionTaskStateSuspended;
    [self.queues changeDownloadTaskToNormalPriorityQueueFromURL:highPriorityNormalTask.currentRequest.URL];
    BOOL isNormalTaskRunnig = isNormalIsSuspended = normalPriorityDownloadTask.state ==NSURLSessionTaskStateRunning;
    BOOL isHighPriorityRunningAfterDemoted = highPriorityNormalTask.state == NSURLSessionTaskStateRunning;
    BOOL isHighPriorityIsNormalPriority = highPriorityNormalTask.priority == NSURLSessionTaskPriorityDefault;
    
    
    
    XCTAssertTrue(self.queues.normalQueueTaskCount == 2 && self.queues.priorityQueueTaskCount == 0 && isNormalIsSuspended && isHighPriorityRunning && isNormalTaskRunnig && isHighPriorityRunningAfterDemoted && isHighPriorityIsNormalPriority);
    
}



- (void)testRemoveAllTaskFromPriorityQueue {
    // Add task1 and task2 to high priority queue
    // removeAlltAsksFromHighpriorityQueue
    // - high priority queue should be empty
    // - task1 should be running, and normal priorty
    // - task2 should be running, and normal priority
    // - normalprioirityqueue should contain 2 items
    NSURLSessionTask *highPrioritySmallTask = [self newSmallDownloadTask];
    NSURLSessionTask *highPriorityBigTask = [self newBigDownloadTask];
    
    [self.queues addDownloadTaskToHighPriorityQueue:highPrioritySmallTask];
    [self.queues addDownloadTaskToHighPriorityQueue:highPriorityBigTask];
    BOOL isPriorityQueueFull = [self.queues priorityQueueTaskCount] == 2;
    [self.queues removeAllTasksFromHighPriorityQueue];
    BOOL isTasksPriorityNormal = highPrioritySmallTask.priority == NSURLSessionTaskPriorityDefault && highPriorityBigTask.priority == NSURLSessionTaskPriorityDefault;
    
    BOOL isTasksStateRunnig = highPrioritySmallTask.state == NSURLSessionTaskStateRunning && highPriorityBigTask.state == NSURLSessionTaskStateRunning;
    BOOL isPriorityQueueEmptyAfterRemove = [self.queues priorityQueueTaskCount] == 0;
    BOOL isNormalQueueFIlled = [self.queues normalQueueTaskCount] == 2;
    XCTAssertTrue(isPriorityQueueFull && isPriorityQueueEmptyAfterRemove && isTasksPriorityNormal && isTasksStateRunnig && isNormalQueueFIlled);
    
}


- (void)testCleanUpForNormalQueue {
    // Add task1  to normal priority queue, and cancelm
    // set task1 status to cancelled
    // Run cleanup on queues
    // - Queue should be empty
    NSURLSessionTask *normalPrioritySmallTask = [self newSmallDownloadTask];

    
    [self.queues addDownloadTaskToNormalPriorityQueue:normalPrioritySmallTask];
    [normalPrioritySmallTask cancel];
    
    [self.queues cleanQueues];
    
    XCTAssertTrue([self.queues normalQueueTaskCount] == 0 &&  [self.queues priorityQueueTaskCount]  == 0);
    
}

- (void)testCleanUpForPriorityQueue {
    // Add task1  to high priority queue, and cancelm
    // set task1 status to cancelled
    // Run cleanup on queues
    // - Queue should be empty
    NSURLSessionTask *normalPrioritySmallTask = [self newSmallDownloadTask];
    
    
    [self.queues addDownloadTaskToHighPriorityQueue:normalPrioritySmallTask];
    [normalPrioritySmallTask cancel];
    
    [self.queues cleanQueues];
    
    XCTAssertTrue([self.queues normalQueueTaskCount] == 0 &&  [self.queues priorityQueueTaskCount]  == 0);
    
}

@end
