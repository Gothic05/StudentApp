/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ctu.student.management;

/**
 *
 * @author Tsitsi
 */
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@RestController
@RequestMapping("/api/students")
public class StudentController {
    private final List<Student> students = new ArrayList<>();
    private final AtomicLong idGenerator = new AtomicLong(1); // Server-side ID generation
    // Initialize with sample data
    public StudentController() {
        students.add(new Student(idGenerator.getAndIncrement(), "Lindeka Mntambo", "LindekaM@ctu.co.za", "Software Engineering"));
        students.add(new Student(idGenerator.getAndIncrement(), "Lethabo Chigo", "LethaboC@ctu.co.za", "Software Developer"));
    }

    // STEP 1: GET /api/students & GET /api/students/{id} 
    @GetMapping
    public ResponseEntity<List<Student>> getAllStudents() {
        return ResponseEntity.ok(students);
    }
    @GetMapping("/{id}")
    public ResponseEntity<Student> getStudentById(@PathVariable Long id) {
        return students.stream()
                .filter(student -> student.getId().equals(id))
                .findFirst()
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // STEP 2: POST /api/students (Assign ID on Server Side) 
    @PostMapping
    public ResponseEntity<Student> createStudent(@RequestBody Student student) {
        // Assign server-generated ID
        student.setId(idGenerator.getAndIncrement());
        students.add(student);
        return new ResponseEntity<>(student, HttpStatus.CREATED);
    }

    // STEP 3: PUT /api/students/{id} (Update Existing Student) 
    @PutMapping("/{id}")
    public ResponseEntity<Student> updateStudent(@PathVariable Long id, @RequestBody Student updatedStudent) {
        for (Student student : students) {
            if (student.getId().equals(id)) {
                student.setName(updatedStudent.getName());
                student.setEmail(updatedStudent.getEmail());
                student.setCourse(updatedStudent.getCourse());
                return ResponseEntity.ok(student);
            }
        }
        return ResponseEntity.notFound().build();
    }

    // STEP 4: DELETE /api/students/{id} (Returns 204 No Content) 
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable Long id) {
        boolean removed = students.removeIf(student -> student.getId().equals(id));
        if (removed) {
            return ResponseEntity.noContent().build(); // HTTP 204 No Content
        }
        return ResponseEntity.notFound().build();
    }
}
