package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.HttpConstraint;
import jakarta.servlet.annotation.ServletSecurity;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/warehouse/page/*")
@ServletSecurity(@HttpConstraint(rolesAllowed = {"WAREHOUSE_MANAGER"}))
public class WarehousePageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/dashboard_content";
        }

        String jspPath = "/WEB-INF/warehouse" + pathInfo + ".jsp";

        try {
            request.getRequestDispatcher(jspPath).forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Page not found!");
        }
    }
}