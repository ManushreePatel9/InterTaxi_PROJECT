package com.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.entity.UsersEntity;

public interface UsersRepo extends JpaRepository<UsersEntity, Integer> {
	
	Optional<UsersEntity> findByEmailAndPassword(String email,String password);
}
