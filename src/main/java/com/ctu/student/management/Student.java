/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ctu.student.management;

/**
 *
 * @author Tsitsi
 */
public class Student {
private Long id;
private String name;
private String email;
private String course;

public Student () {}

public Student (Long id, String name, String email, String course) {
    this.id = id;
    this. name = name;
    this.email = email;
    this.course = course;
}

// Getters and Setters
public Long getId() { return id; }
public void setId(Long id) { this.id = id; }

public String getName() { return name; }
public void setName (String name) { this.name = name; }

public String getEmail() { return email; }
public void setEmail(String email) { this.email = email; }

public String getCourse() { return course; }
public void setCourse (String course) { this.course = course; }
}
