module TifiTasks
  class Async
    def perform
      if task = AsyncJob::Task.first
        task.perform
        task.destroy
      end
    end
  end
end
