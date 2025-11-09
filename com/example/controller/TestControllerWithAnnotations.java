package com.example.controller;

import com.example.annotations.Controller;
import com.example.annotations.GetMapping;

@Controller("testController")
public class TestControllerWithAnnotations {
    
    @GetMapping("/test")
    public String testMethod() {
        return "Test method";
    }
    
    @GetMapping("/hello")
    public String helloMethod() {
        return "Hello world";
    }
    
    public String methodWithoutAnnotation() {
        return "No annotation";
    }
}
