package lk.logistic.dto;

public class CustomerLoginDTO {
    private String email;
    private String password;


    public CustomerLoginDTO() {}


    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}