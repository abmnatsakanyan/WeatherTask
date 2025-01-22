//
//  BackgroundService.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import Foundation
import BackgroundTasks

protocol BackgroundServiceable {
    func start(complition: @escaping (() -> Void))
}

/**
 https://developer.apple.com/documentation/backgroundtasks/starting-and-terminating-tasks-during-development#Launch-a-Task
 
 To launch a task:
 1. Set a breakpoint in the code that executes after a successful call to submit(_:).
 2. Run your app on a device until the breakpoint pauses your app.
 3. In the debugger, execute the line shown below
 e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"background.update.weather"]
 4. Resume your app. The system calls the launch handler for the desired task.
 */

final class BackgroundService: BackgroundServiceable {
    private let taskId = "background.update.weather"
    private var onTaskCompleted: (() -> Void)?
    
    func start(complition: @escaping (() -> Void)) {
        self.onTaskCompleted = complition
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
            guard let task = task as? BGProcessingTask else { return }
            self.handleTask(task: task)
        }
        
        submitBackgroundTask()
    }
    
    private func submitBackgroundTask() {
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            print("\(requests.count) BGTask pending.")
            guard requests.isEmpty else { return }

            let request = BGProcessingTaskRequest(identifier: self.taskId)
            request.requiresNetworkConnectivity = true
            request.requiresExternalPower = false
            request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 3600)
            
            do {
                try BGTaskScheduler.shared.submit(request)
                // 👈 Set breakpoint here for testing background task with debuger
                print("Background task submitted.")
            } catch {
                print("Unable to schedule background task: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleTask(task: BGProcessingTask) {
        onTaskCompleted?()

        task.setTaskCompleted(success: true)
    }
}
