import com.example.annotations.HandleURL;

public class Teste {
    @HandleURL("/hello")
    public void hello() {}

    @HandleURL("/about")
    public void about() {}

    @HandleURL("/home")
    public void home() {}
}
