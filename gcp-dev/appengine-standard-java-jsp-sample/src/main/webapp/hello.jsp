<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="appBean" class="nz.net.osnz.appengine.App" />
<html>
<head>
    <title>AppEngine Java JSP Page</title>
    <link rel="stylesheet" href="/css/main.css" />
    <link rel="stylesheet" href="/vendor/main.css" />
</head>
<body>
    <h1>Hello From Appengine</h1>
    ${appBean.getInfo()}
</body>
</html>
