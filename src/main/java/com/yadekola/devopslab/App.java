package com.yadekola.devopslab;

public class App {

    public String getMessage() {
        return "DevOps Lab App is running!";
    }

    public static void main(String[] args) {
        App app = new App();
        System.out.println(app.getMessage());
    }
}
