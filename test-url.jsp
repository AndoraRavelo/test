<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test URL Mapping</title>
    <link rel="stylesheet" href="styles.css" />
    <style>
        body { font-family: Arial, sans-serif; margin: 2rem; }
        .ok { color: green; }
        .err { color: #b00020; }
        form { margin-top: 1rem; }
        label { display:block; margin-bottom: .5rem; }
        input[type=text] { width: 360px; padding:.4rem; }
        button { padding:.4rem .8rem; }
        .card { border:1px solid #ddd; padding:1rem; border-radius:8px; max-width: 600px; }
    </style>
</head>
<body>
<h1>Test du mapping d'URL (@GetMapping)</h1>
<div class="card">
    <form action="<%= request.getContextPath() %>/testUrl" method="post">
        <label for="url">Entrez une URL à rechercher (ex: /hello, /home, ...)
            <br>
            Les URL existant sont:
            <br> /test,
            <br> /hello,
            <br> /simple
        </label>
        <input type="text" id="url" name="url" value="<%= request.getAttribute("searchUrl") != null ? request.getAttribute("searchUrl") : "" %>">
        <button type="submit">Rechercher</button>
    </form>
    <hr/>
    <%
        Object result = request.getAttribute("result");
        if (result != null) {
            boolean found = Boolean.TRUE.equals(request.getAttribute("found"));
            if (found) {
    %>
                <p class="ok">Mapping trouvé pour <b><%= request.getAttribute("searchUrl") %></b></p>
                <ul>
                    <li>Classe: <b><%= request.getAttribute("className") %></b></li>
                    <li>Méthode: <b><%= request.getAttribute("methodName") %></b></li>
                </ul>
    <%
            } else {
    %>
                <p class="err">Aucun mapping trouvé pour <b><%= request.getAttribute("searchUrl") %></b></p>
    <%
            }
        }
    %>
</div>
</body>
</html>
