package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.HttpConstraint;
import jakarta.servlet.annotation.ServletSecurity;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login-redirect")
@ServletSecurity(@HttpConstraint(rolesAllowed = {"LOGISTICS_COORDINATOR", "WAREHOUSE_MANAGER","CUSTOMS_OFFICER","VENDOR","CUSTOMER"}))
public class LoginRedirectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        if (request.getUserPrincipal() == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }


        if (request.isUserInRole("WAREHOUSE_MANAGER")) {
            request.getRequestDispatcher("/WEB-INF/warehouse/dashboard.jsp").forward(request, response);
        }

        else if (request.isUserInRole("LOGISTICS_COORDINATOR")) {
            request.getRequestDispatcher("/WEB-INF/logistic/dashboard.jsp").forward(request, response);
        }

        else if(request.isUserInRole("CUSTOMS_OFFICER")){
            request.getRequestDispatcher("/WEB-INF/custom/dashboard.jsp").forward(request, response);

        }
        else if(request.isUserInRole("VENDOR")){
            request.getRequestDispatcher("/WEB-INF/vendor/dashboard.jsp").forward(request, response);

        }else if(request.isUserInRole("CUSTOMER")){
            request.getRequestDispatcher("/WEB-INF/customer/dashboard.jsp").forward(request, response);

        }
        else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: No valid role found.");
        }
    }
}