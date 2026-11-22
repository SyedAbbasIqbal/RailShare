package com.railshare.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.railshare.dao.FareDAO;
import com.railshare.model.Fare;

@WebServlet("/admin/fare")
public class FareServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private FareDAO fareDAO;

    @Override
    public void init() {
        fareDAO = new FareDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Admin access check
        HttpSession session = request.getSession(false);

        if (session == null ||
                !"ADMIN".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "view";
        }

        switch (action) {

            case "delete":

                int id = Integer.parseInt(
                        request.getParameter("id"));

                fareDAO.deleteFare(id);

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/fare?action=view");

                break;

            case "edit":

                int editId = Integer.parseInt(
                        request.getParameter("id"));

                Fare fare = fareDAO.getFareById(editId);

                request.setAttribute(
                        "editFare",
                        fare);

                // fall through

            case "view":

                List<Fare> fares = fareDAO.getAllFares();

                request.setAttribute(
                        "fares",
                        fares);

                request.getRequestDispatcher(
                        "/admin/fares.jsp")
                        .forward(
                                request,
                                response);

                break;

            default:

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/fare?action=view");
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !"ADMIN".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        String idStr = request.getParameter("id");

        Fare fare = new Fare();

        fare.setTrainNumber(
                request.getParameter(
                        "trainNumber"));

        fare.setFromStation(
                request.getParameter(
                        "fromStation"));

        fare.setToStation(
                request.getParameter(
                        "toStation"));

        fare.setTicketClass(
                request.getParameter(
                        "ticketClass"));

        fare.setFareAmount(
                new BigDecimal(
                        request.getParameter(
                                "fareAmount")));

        // Update
        if (idStr != null &&
                !idStr.isEmpty()) {

            fare.setId(
                    Integer.parseInt(idStr));

            fareDAO.updateFare(fare);

        } else {

            // Add
            fareDAO.addFare(fare);
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/fare?action=view");
    }
}