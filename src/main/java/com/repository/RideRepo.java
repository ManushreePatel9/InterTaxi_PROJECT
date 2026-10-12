package com.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.entity.BookRideEntity;

public interface RideRepo extends JpaRepository<BookRideEntity, Integer>{
	@Query(value = "SELECT P2.* FROM ride_requests P1 " +
            "JOIN ride_requests P2 " +
            "  ON ABS(P1.drop_lat - P2.pickup_lat) <= 0.3 " +
            " AND ABS(P1.drop_lng - P2.pickup_lng) <= 0.3 " +
            " AND ABS(P1.pickup_lat - P2.drop_lat) <= 0.3 " +
            " AND ABS(P1.pickup_lng - P2.drop_lng) <= 0.3 " +
            "WHERE P1.request_id = :forwardRequestId " +
            "  AND LOWER(P1.status) = 'pending' " +
            "  AND LOWER(P2.status) = 'pending' " +
            "  AND P1.request_id != P2.request_id", 
    nativeQuery = true)
	
List<BookRideEntity> findPotentialReturnMatches(
     @Param("forwardRequestId") Integer forwardRequestId
);
	
	
	

}
