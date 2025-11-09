package com.example.controller;

import com.example.annotations.Controller;
import com.example.annotations.GetMapping;

@Controller
public class SimpleControllerWithoutClassAnnotation {
    
    @GetMapping("/simple")
    public String simpleMethod() {
        return "Simple method";
    }
    
    @GetMapping("/another")
    public String anotherMethod() {
        return "Another method";
    }
}
