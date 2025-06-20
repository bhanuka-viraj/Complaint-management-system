package com.bhanuka.cms.controller;

import com.bhanuka.cms.model.dao.ComplaintDAO;
import com.bhanuka.cms.model.dto.ComplaintDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        ComplaintDAO complaintDAO = new ComplaintDAO();
        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        try {
            List<ComplaintDTO> complaints;
            if ("Admin".equals(role)) {
                complaints = complaintDAO.getAllComplaints();
            } else {
                complaints = complaintDAO.getComplaintsByUserId(userId);
            }

            request.setAttribute("complaints", complaints);

            String submitParam = request.getParameter("submit");
            if ("true".equalsIgnoreCase(submitParam)) {
                request.setAttribute("isSubmitting", "true");
            }


            String editIdParam = request.getParameter("editId");
            if (editIdParam != null) {
                int editId = Integer.parseInt(editIdParam);
                ComplaintDTO editingComplaint = complaintDAO.getComplaintById(editId);
                if (editingComplaint != null && ("Admin".equals(role) || editingComplaint.getUserId() == userId)) {
                    if (!("Employee".equals(role) && "Resolved".equals(editingComplaint.getStatus()))) {
                        request.setAttribute("isEditing", "true");
                        request.setAttribute("editingComplaint", editingComplaint);
                    } else {
                        request.setAttribute("error", "Cannot edit a resolved complaint.");
                    }
                } else {
                    request.setAttribute("error", "Unauthorized or complaint not found.");
                }
            }

            request.getRequestDispatcher("/WEB-INF/view/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the dashboard.");
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }
}