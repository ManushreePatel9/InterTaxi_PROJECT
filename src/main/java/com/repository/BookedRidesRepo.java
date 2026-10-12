package com.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.entity.BookedRidesEntity;
import com.entity.UsersEntity;

@Repository
public interface BookedRidesRepo extends JpaRepository<BookedRidesEntity, Integer> {
    
    // Driver ki saari booked rides fetch karne ke liye (Future Use)
    List<BookedRidesEntity> findByDriver(UsersEntity driver);
    
 // Driver ki booked rides fetch karne ke liye (b = BookedRidesEntity, driver = UsersEntity, userId = primary key)
    @Query("SELECT b FROM BookedRidesEntity b WHERE b.driver.userId = :driverId")
    List<BookedRidesEntity> findBookedRidesForDriver(@Param("driverId") Integer driverId);

    // Passenger ki booked rides fetch karne ke liye (Forward ya Return ride ke passenger ki user.userId match karenge)
//    @Query("SELECT b FROM BookedRidesEntity b WHERE b.forwardRide.user.userId = :passengerId OR b.returnRide.user.userId = :passengerId")
//    List<BookedRidesEntity> findBookedRidesForPassenger(@Param("passengerId") Integer passengerId);

    
// // FIXED: Null-safe Passenger Search (Supports both Single and Matched Rides)
//    @Query("SELECT b FROM BookedRidesEntity b WHERE " +
//           "(b.forwardRide IS NOT NULL AND b.forwardRide.user.userId = :passengerId) OR " +
//           "(b.returnRide IS NOT NULL AND b.returnRide.user.userId = :passengerId)")
//    List<BookedRidesEntity> findBookedRidesForPassenger(@Param("passengerId") Integer passengerId);
//    
 // FIXED QUERY: Left Join ensures NULL returnRide doesn't filter out Single Rides!
    @Query("SELECT b FROM BookedRidesEntity b " +
           "LEFT JOIN b.forwardRide f " +
           "LEFT JOIN b.returnRide r " +
           "WHERE (f IS NOT NULL AND f.user.userId = :passengerId) " +
           "OR (r IS NOT NULL AND r.user.userId = :passengerId)")
    List<BookedRidesEntity> findBookedRidesForPassenger(@Param("passengerId") Integer passengerId);

}