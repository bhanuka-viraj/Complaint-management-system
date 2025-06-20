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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        ComplaintDAO complaintDAO = new ComplaintDAO();
        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        System.out.println("doGet - PathInfo: " + pathInfo + ", Role: " + role);

        try {
            if ("/submit".equals(pathInfo) && !"Admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?submit=true");
            } else if ("/myComplaints".equals(pathInfo)) {
                List<ComplaintDTO> complaints = complaintDAO.getComplaintsByUserId(userId);
                request.setAttribute("complaints", complaints);
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else if ("/allComplaints".equals(pathInfo)) {
                if ("Admin".equals(role)) {
                    List<ComplaintDTO> complaints = complaintDAO.getAllComplaints();
                    if (complaints == null || complaints.isEmpty()) {
                        request.setAttribute("message", "No complaints found.");
                    } else {
                        request.setAttribute("complaints", complaints);
                    }
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admins only.");
                }
            } else if (pathInfo != null && pathInfo.startsWith("/edit/")) {
                String idStr = pathInfo.substring("/edit/".length());
                int complaintId = Integer.parseInt(idStr);
                List<ComplaintDTO> complaints = "Admin".equals(role) ? complaintDAO.getAllComplaints() : complaintDAO.getComplaintsByUserId(userId);
                ComplaintDTO complaint = complaints.stream().filter(c -> c.getId() == complaintId).findFirst().orElse(null);
                if (complaint == null || (complaint.getUserId() != userId && !"Admin".equals(role))) {
                    request.setAttribute("error", "Unauthorized or complaint not found.");
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else if ((complaint.getUserId() == userId && "Resolved".equals(complaint.getStatus()) && !"Admin".equals(role))) {
                    request.setAttribute("error", "Cannot edit a resolved complaint.");
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?editId=" + complaintId);
                }
            } else if (pathInfo != null && pathInfo.startsWith("/delete/")) {
                String idStr = pathInfo.substring("/delete/".length());
                int complaintId = Integer.parseInt(idStr);
                ComplaintDTO complaint = complaintDAO.getComplaintById(complaintId);
                if (complaint == null || (complaint.getUserId() != userId && !"Admin".equals(role))) {
                    request.setAttribute("error", "Unauthorized or complaint not found.");
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else if ("Resolved".equals(complaint.getStatus()) && complaint.getUserId() == userId && !"Admin".equals(role)) {
                    request.setAttribute("error", "Cannot delete a resolved complaint.");
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    complaintDAO.deleteComplaint(complaintId);
                    List<ComplaintDTO> complaints = "Admin".equals(role) ? complaintDAO.getAllComplaints() : complaintDAO.getComplaintsByUserId(userId);
                    request.setAttribute("complaints", complaints);
                    if ("Admin".equals(role) && (complaints == null || complaints.isEmpty())) {
                        request.setAttribute("message", "No complaints found.");
                    }
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        ComplaintDAO complaintDAO = new ComplaintDAO();
        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        System.out.println("doPost - PathInfo: " + pathInfo + ", Role: " + role);

        try {
            if ("/submit".equals(pathInfo) && !"Admin".equals(role)) {
                ComplaintDTO complaint = new ComplaintDTO();
                complaint.setUserId(userId);
                complaint.setTitle(request.getParameter("title"));
                complaint.setDescription(request.getParameter("description"));
                complaint.setStatus("Pending");
                complaint.setRemarks(request.getParameter("remarks"));
                complaintDAO.saveComplaint(complaint);
                List<ComplaintDTO> complaints = complaintDAO.getComplaintsByUserId(userId);
                request.setAttribute("complaints", complaints);
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else if ("/edit".equals(pathInfo)) {
                System.out.println("Processing /edit POST with parameters: " + request.getParameterMap());
                String idStr = request.getParameter("id");
                if (idStr == null || idStr.trim().isEmpty()) {
                    request.setAttribute("error", "Invalid complaint ID.");
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }
                int complaintId = Integer.parseInt(idStr);
                ComplaintDTO complaint = complaintDAO.getComplaintById(complaintId);
                if (complaint == null || (complaint.getUserId() != userId && !"Admin".equals(role))) {
                    request.setAttribute("error", "Unauthorized or complaint not found.");
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }
                if ("Resolved".equals(complaint.getStatus()) && complaint.getUserId() == userId && !"Admin".equals(role)) {
                    request.setAttribute("error", "Cannot edit a resolved complaint.");
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }
                complaint.setTitle(request.getParameter("title"));
                complaint.setDescription(request.getParameter("description"));

                if (!"Admin".equals(role)) {
                    complaint.setRemarks(complaint.getRemarks());
                    complaint.setStatus(complaint.getStatus());
                } else {
                    complaint.setRemarks(request.getParameter("remarks"));
                    complaint.setStatus(request.getParameter("status"));
                }
                complaintDAO.updateComplaint(complaint);
                System.out.println("Update successful, forwarding to dashboard for role: " + role);
                List<ComplaintDTO> complaints = "Admin".equals(role) ? complaintDAO.getAllComplaints() : complaintDAO.getComplaintsByUserId(userId);
                request.setAttribute("complaints", complaints);
                if ("Admin".equals(role) && (complaints == null || complaints.isEmpty())) {
                    request.setAttribute("message", "No complaints found.");
                }
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                System.out.println("404 triggered for pathInfo: " + pathInfo);
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }
}