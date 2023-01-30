package com.company.project.persistence.repository;

import org.springframework.data.repository.PagingAndSortingRepository;

import com.company.project.persistence.model.Project;

public interface IProjectRepository extends PagingAndSortingRepository<Project, Long> {

}
