import java.lang.reflect.Method;
import com.example.annotations.HandleURL;

public class Main {
    public static void main(String[] args) {
        Class<?> clazz = Teste.class;
        System.out.println("URLs trouvées dans la classe " + clazz.getSimpleName() + ":");
        for (Method m : clazz.getDeclaredMethods()) {
            if (m.isAnnotationPresent(HandleURL.class)) {
                HandleURL ann = m.getAnnotation(HandleURL.class);
                System.out.println(ann.value());
            }
        }
    }
}
