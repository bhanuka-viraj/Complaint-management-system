# Complaint Management System

A web-based application for efficiently managing and tracking complaints, designed for employees and admins.

## Overview

The Complaint Management System (CMS) allows users to submit, edit, and delete complaints, with role-based access:
- **Employees** can submit new complaints, view their own complaints, and edit/delete non-resolved complaints.
- **Admins** can view all complaints, edit any complaint (including status and remarks), and manage the system.

The system is built using Java Servlets, JSP, and Bootstrap, with a MySQL database for storage.

## Features

- User authentication with role-based access (Employee/Admin).
- Submit new complaints with details.
- View and manage personal or all complaints in a dashboard.
- Edit complaints (title and description for employees; all + status and remarks for admins).
- Delete complaints (restricted for resolved complaints by employees).

## Prerequisites

- Java Development Kit (JDK) 11 or higher.
- Apache Tomcat 9.x or higher.
- MySQL Server 5.7 or higher.
- IntelliJ IDEA or another Java IDE (recommended).

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/bhanuka-viraj/Complaint-management-system.git
   cd complaint-management-system