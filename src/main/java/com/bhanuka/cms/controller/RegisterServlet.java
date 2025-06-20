package com.bhanuka.cms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle GET request to show the registration form
        request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle POST request for registration submission
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // e.g., "Employee" or "Admin"

        com.bhanuka.cms.model.dao.UserDAO userDAO = new com.bhanuka.cms.model.dao.UserDAO();
        boolean success = userDAO.register(username, password, role);

        if (success) {
            request.setAttribute("message", "Registration successful! Please log in.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Username may already exist.");
            request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
        }
    }
}