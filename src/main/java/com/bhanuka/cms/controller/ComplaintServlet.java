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

@WebServlet("/complaint/*")
public class ComplaintServlet extends HttpServlet {
    private ComplaintDAO complaintDAO = new ComplaintDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if ("/submit".equals(pathInfo)) {
            request.getRequestDispatcher("/WEB-INF/view/submitComplaint.jsp").forward(request, response);
        } else if ("/list".equals(pathInfo)) {
            List<ComplaintDTO> complaints = (role.equals("Admin")) ? complaintDAO.getAllComplaints() : complaintDAO.getComplaintsByUserId(userId);
            request.setAttribute("complaints", complaints);
            request.getRequestDispatcher("/WEB-INF/view/complaintList.jsp").forward(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            int id = Integer.parseInt(pathInfo.substring(6)); // Extract ID from /edit/{id}
            ComplaintDAO dao = new ComplaintDAO();
            List<ComplaintDTO> complaints = dao.getAllComplaints(); // Admin can edit any; adjust if only own complaints
            ComplaintDTO complaint = complaints.stream().filter(c -> c.getId() == id).findFirst().orElse(null);
            if (complaint != null && (role.equals("Admin") || complaint.getUserId() == userId)) {
                request.setAttribute("complaint", complaint);
                request.getRequestDispatcher("/WEB-INF/view/editComplaint.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/complaint/list");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        int userId = (int) session.getAttribute("userId");

        if ("/submit".equals(pathInfo)) {
            ComplaintDTO complaint = new ComplaintDTO();
            complaint.setUserId(userId);
            complaint.setTitle(request.getParameter("title"));
            complaint.setDescription(request.getParameter("description"));
            complaint.setStatus("Pending");
            complaint.setRemarks("");
            new ComplaintDAO().saveComplaint(complaint);
            response.sendRedirect(request.getContextPath() + "/complaint/list");
        } else if ("/update".equals(pathInfo)) {
            int id = Integer.parseInt(request.getParameter("id"));
            ComplaintDTO complaint = new ComplaintDTO();
            complaint.setId(id);
            complaint.setStatus(request.getParameter("status"));
            complaint.setRemarks(request.getParameter("remarks"));
            new ComplaintDAO().updateComplaint(complaint);
            response.sendRedirect(request.getContextPath() + "/complaint/list");
        } else if ("/delete".equals(pathInfo)) {
            int id = Integer.parseInt(request.getParameter("id"));
            new ComplaintDAO().deleteComplaint(id);
            response.sendRedirect(request.getContextPath() + "/complaint/list");
        }
    }
}