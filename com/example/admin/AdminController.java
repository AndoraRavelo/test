package com.example.admin;

import com.example.annotations.Controller;
import com.example.annotations.GetMapping;

@Controller
public class AdminController {
    
    @GetMapping("/admin/dashboard")
    public String dashboard() {
        return "Admin dashboard";
    }
    
    @GetMapping("/admin/settings")
    public String settings() {
        return "Admin settings";
    }
}
