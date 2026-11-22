package com.railshare.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.railshare.dao.FareDAO;
import com.railshare.dao.TicketDAO;
import com.railshare.model.Ticket;
import com.railshare.model.User;
import com.railshare.util.PriceCalculator;
import com.railshare.util.ValidationUtil;

@WebServlet("/ticket")
public class TicketServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TicketDAO ticketDAO;
    private FareDAO fareDAO;

    @Override
    public void init() throws ServletException {

        ticketDAO =
                new TicketDAO();

        fareDAO =
                new FareDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException,
            IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("user")
                        == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        User user =
                (User) session
                        .getAttribute("user");

        String action =
                request.getParameter(
                        "action");

        if ("list".equals(action)) {

            request.getRequestDispatcher(
                    "/seller/list-ticket.jsp")
                    .forward(request,
                            response);
        }

        else if ("my-tickets"
                .equals(action)) {

            request.setAttribute(
                    "tickets",

                    ticketDAO
                            .getTicketsBySeller(
                                    user.getId()));

            request.getRequestDispatcher(
                    "/seller/my-tickets.jsp")
                    .forward(request,
                            response);
        }

        else if ("browse"
                .equals(action)) {

            String searchDate =
                    request.getParameter(
                            "searchDate");

            String searchTrain =
                    request.getParameter(
                            "searchTrain");

            String searchClass =
                    request.getParameter(
                            "searchClass");

            String fromStation =
                    request.getParameter(
                            "fromStation");

            String toStation =
                    request.getParameter(
                            "toStation");

            String timeFilter =
                    request.getParameter(
                            "timeFilter");

            request.setAttribute(
                    "tickets",

                    ticketDAO
                            .getAvailableTickets(
                                    searchDate,
                                    searchTrain,
                                    searchClass,
                                    fromStation,
                                    toStation,
                                    timeFilter
                            ));

            request.getRequestDispatcher(
                    "/buyer/browse-tickets.jsp")
                    .forward(request,
                            response);
        }

        else {

            response.sendRedirect(
                    request.getContextPath()
                            + "/index.jsp");
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException,
            IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("user")
                        == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        User user =
                (User) session
                        .getAttribute("user");

        String trainNumber =
                request.getParameter(
                        "trainNumber");

        String fromStation =
                request.getParameter(
                        "fromStation");

        String toStation =
                request.getParameter(
                        "toStation");

        String travelDateStr =
                request.getParameter(
                        "travelDate");

        String travelTimeStr =
                request.getParameter(
                        "travelTime");

        String seatType =
                request.getParameter(
                        "seatType");

        String coachNo =
                request.getParameter(
                        "coachNo");

        String seatNo =
                request.getParameter(
                        "seatNo");

        String ticketClass =
                request.getParameter(
                        "class");

        String pnr =
                request.getParameter(
                        "pnr");

        if (trainNumber == null ||
                fromStation == null ||
                toStation == null ||
                travelDateStr == null ||
                travelTimeStr == null ||
                seatType == null ||
                coachNo == null ||
                seatNo == null ||
                ticketClass == null ||
                pnr == null) {

            request.setAttribute(
                    "error",
                    "All fields are required");

            request.getRequestDispatcher(
                    "/seller/list-ticket.jsp")
                    .forward(request,
                            response);

            return;
        }

        try {

            Date travelDate =
                    Date.valueOf(
                            travelDateStr);

            Time travelTime =
                    Time.valueOf(
                            travelTimeStr
                                    + ":00");

            String validationError =
                    ValidationUtil
                            .validateTicket(
                                    trainNumber,
                                    pnr,
                                    travelDate,
                                    travelTime
                            );

            if (validationError != null) {

                request.setAttribute(
                        "error",
                        validationError);

                request.getRequestDispatcher(
                        "/seller/list-ticket.jsp")
                        .forward(request,
                                response);

                return;
            }

            if (ticketDAO
                    .pnrExists(
                            pnr)) {

                request.setAttribute(
                        "error",

                        "This PNR has already been listed");

                request.getRequestDispatcher(
                        "/seller/list-ticket.jsp")
                        .forward(request,
                                response);

                return;
            }

            BigDecimal baseFare =
                    fareDAO
                            .getFareAmount(
                                    trainNumber,
                                    fromStation,
                                    toStation,
                                    ticketClass
                            );

            if (baseFare == null) {

                request.setAttribute(
                        "error",
                        "Fare not found for this route.");

                request.getRequestDispatcher(
                        "/seller/list-ticket.jsp")
                        .forward(request,
                                response);

                return;
            }

            BigDecimal serviceFee =
                    PriceCalculator
                            .calculateServiceFee(
                                    baseFare);

            BigDecimal totalAmount =
                    PriceCalculator
                            .calculateTotal(
                                    baseFare);

            Ticket ticket =
                    new Ticket();

            ticket.setSellerId(
                    user.getId());

            ticket.setTrainNumber(
                    trainNumber);

            ticket.setFromStation(
                    fromStation);

            ticket.setToStation(
                    toStation);

            ticket.setTravelDate(
                    travelDate);

            ticket.setTravelTime(
                    travelTime);

            ticket.setTicketClass(
                    ticketClass);

            ticket.setSeatType(
                    seatType);

            ticket.setCoachNo(
                    coachNo);

            ticket.setSeatNo(
                    seatNo);

            ticket.setPnr(
                    pnr);

            ticket.setPrice(
                    baseFare);

            ticket.setServiceFee(
                    serviceFee);

            ticket.setTotalAmount(
                    totalAmount);

            ticket.setStatus(
                    "AVAILABLE");

            boolean success =
                    ticketDAO
                            .createTicket(
                                    ticket);

            if (success) {

                request.setAttribute(
                        "success",

                        "Ticket listed successfully!");

            } else {

                request.setAttribute(
                        "error",
                        "Failed to list ticket.");
            }

            request.getRequestDispatcher(
                    "/seller/list-ticket.jsp")
                    .forward(request,
                            response);

        }

        catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Error: "
                            + e.getMessage());

            request.getRequestDispatcher(
                    "/seller/list-ticket.jsp")
                    .forward(request,
                            response);
        }
    }
}