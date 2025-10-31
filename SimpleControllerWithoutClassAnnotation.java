import com.example.annotations.GetMapping;

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
