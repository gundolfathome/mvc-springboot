package com.company.project.service.impl;

import java.util.Optional;
import org.springframework.stereotype.Service;

import com.company.project.persistence.model.Task;
import com.company.project.persistence.repository.ITaskRepository;
import com.company.project.service.ITaskService;

@Service
public class TaskServiceImpl implements ITaskService {
	
    private ITaskRepository taskRepository;

    public TaskServiceImpl(ITaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    @Override
    public Optional<Task> findById(Long id) {
        return taskRepository.findById(id);
    }

    @Override
    public Task save(Task project) {
        return taskRepository.save(project);
    }
}
