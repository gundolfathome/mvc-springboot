package com.company.project.service.impl;

import java.time.LocalDate;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.company.project.persistence.model.Project;
import com.company.project.persistence.repository.IProjectRepository;
import com.company.project.service.IProjectService;


@Service
public class ProjectServiceImpl implements IProjectService {

	private IProjectRepository projectRepository;

    public ProjectServiceImpl(IProjectRepository projectRepository) {
        this.projectRepository = projectRepository;
    }

	@Override
	public Optional<Project> findById(Long id) {
		 return projectRepository.findById(id);
	}

	@Override
	public Project save(Project project) {
        if (null == project.getId()) {
            project.setDateCreated(LocalDate.now());
        }
        return projectRepository.save(project);
	}

	@Override
	public Iterable<Project> findAll() {
		 return projectRepository.findAll();
	}

}
