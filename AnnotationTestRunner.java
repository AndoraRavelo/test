import com.example.annotations.AnnotationReader;
import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class AnnotationTestRunner {
    
    public static void main(String[] args) {
        System.out.println("=== Test des annotations ===\n");
        
        // Liste manuelle des classes de test
        Class<?>[] testClasses = {
            TestFramework.class,
            TestControllerWithAnnotations.class,
            SimpleControllerWithoutClassAnnotation.class,
            ClassWithoutAnnotations.class
        };
        
        System.out.println("Classes de test:");
        for (Class<?> clazz : testClasses) {
            System.out.println("- " + clazz.getSimpleName());
        }
        System.out.println();
        
        // Afficher les classes qui utilisent @GetMapping au niveau méthode
        AnnotationReader.displayClassesWithAnnotations(testClasses);
        
        System.out.println("\n=== Test individuel des classes ===");
        
        // Test individuel de chaque classe
        for (Class<?> clazz : testClasses) {
            System.out.println("\nTest de la classe: " + clazz.getSimpleName());
            try {
                AnnotationReader.readGetMappingAnnotations(clazz);
            } catch (Exception e) {
                System.out.println("Erreur lors du test de " + clazz.getSimpleName() + ": " + e.getMessage());
            }
        }
    }
}
