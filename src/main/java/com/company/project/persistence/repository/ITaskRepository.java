package com.company.project.persistence.repository;

import org.springframework.data.repository.CrudRepository;

import com.company.project.persistence.model.Task;

public interface ITaskRepository extends CrudRepository<Task, Long> {

}
