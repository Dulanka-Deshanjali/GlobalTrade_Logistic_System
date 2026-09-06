package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.HttpConstraint;
import jakarta.servlet.annotation.ServletSecurity;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/custom/page/*")
@ServletSecurity(@HttpConstraint(rolesAllowed = {"CUSTOMS_OFFICER"}))
public class CustomPageController extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/dashboard";
        }

        String jspPath = "/WEB-INF/custom" + pathInfo + ".jsp";

        try {
            request.getRequestDispatcher(jspPath).forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Page not found!");
        }
    }
}
