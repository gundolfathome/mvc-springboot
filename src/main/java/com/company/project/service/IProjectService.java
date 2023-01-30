package com.company.project.service;

import java.util.Optional;
import com.company.project.persistence.model.Project;

public interface IProjectService {

	Optional<Project> findById(Long id);
    Project save(Project project);
    Iterable<Project> findAll();
}
