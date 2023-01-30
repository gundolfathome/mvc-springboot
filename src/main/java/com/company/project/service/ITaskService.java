package com.company.project.service;

import java.util.Optional;
import com.company.project.persistence.model.Task;

public interface ITaskService {
	
    Optional<Task> findById(Long id);
    Task save(Task task);
}
