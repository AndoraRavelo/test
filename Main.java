package com.example;

import com.example.annotations.AnnotationReader;

public class Main {
    
    public static void main(String[] args) {
        System.out.println("=== Démarrage de l'application ===");
        System.out.println();
        
        // Initialisation du système au démarrage (scan des URLs une seule fois)
        AnnotationReader.init();
        
        System.out.println();
        System.out.println("=== Affichage des classes scannées ===");
        System.out.println();
        // Le package de base est défini dans config.properties
        AnnotationReader.displayClassesWithAnnotations();
        
        System.out.println();
        System.out.println("=== Test de recherche d'URL ===");
        System.out.println();
        
        // Test avec des URLs existantes
        testUrl("/test");
        testUrl("/hello");
        testUrl("/simple");
        testUrl("/another");
        testUrl("/admin/dashboard");
        testUrl("/admin/settings");
        
        // Test avec une URL non existante
        testUrl("/nonexistent");
        testUrl("/api/test");
    }
    
    private static void testUrl(String url) {
        System.out.println();
        System.out.println("Recherche de l'URL: " + url);
        AnnotationReader.displayMappingForUrl(url);
    }
}
