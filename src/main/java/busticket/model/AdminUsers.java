/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class AdminUsers {

    private int user_id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String role;
    private String status;
    private Timestamp birthdate;
    private String gender;
    private String address;
    private Timestamp created_at;

    public String getFormattedId() {
        return String.format("ACC %04d", user_id);
    }

    public AdminUsers() {

    }

    public AdminUsers(int user_id, String name, String email, String password, String phone, String role, String status, Timestamp birthdate, String gender, String address, Timestamp created_at) {
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.status = status;
        this.birthdate = birthdate;
        this.gender = gender;
        this.address = address;
        this.created_at = created_at;
    }

    public AdminUsers(String name, String email, String password, String phone, String role, String status, Timestamp birthdate, String gender, String address, Timestamp created_at) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.status = status;
        this.birthdate = birthdate;
        this.gender = gender;
        this.address = address;
        this.created_at = created_at;
    }

    public AdminUsers(String name, String email, String phone, String role, String status, Timestamp birthdate, String gender, String address) {
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.status = status;
        this.birthdate = birthdate;
        this.gender = gender;
        this.address = address;
    }

    public AdminUsers(int user_id, String name, String email, String phone, String role, String status, Timestamp created_at) {
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.status = status;
        this.created_at = created_at;
    }

    public AdminUsers(int user_id, String name, String email, String phone, String role, String status, Timestamp birthdate, String gender, String address) {
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.status = status;
        this.birthdate = birthdate;
        this.gender = gender;
        this.address = address;
    }

    public AdminUsers(int user_id, String name) {
        this.user_id = user_id;
        this.name = name;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getBirthdate() {
        return birthdate;
    }

    public void setBirthdate(Timestamp birthdate) {
        this.birthdate = birthdate;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

}
