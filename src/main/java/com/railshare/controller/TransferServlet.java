package com.railshare.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.railshare.dao.TicketDAO;
import com.railshare.dao.TransferDAO;
import com.railshare.model.Ticket;
import com.railshare.model.Transfer;
import com.railshare.model.User;

@WebServlet("/transfer")
public class TransferServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TicketDAO ticketDAO;
    private TransferDAO transferDAO;

    @Override
    public void init()
            throws ServletException {

        ticketDAO =
                new TicketDAO();

        transferDAO =
                new TransferDAO();
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

        String passengerName =
                request.getParameter(
                        "passengerName");

        String ageStr =
                request.getParameter(
                        "age");

        String gender =
                request.getParameter(
                        "gender");

        String ticketIdStr =
                request.getParameter(
                        "ticketId");

        if (ticketIdStr == null ||
                ticketIdStr.trim()
                        .isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/ticket?action=browse");

            return;
        }

        try {

            int ticketId =
                    Integer.parseInt(
                            ticketIdStr);

            Ticket ticket =
                    ticketDAO
                            .getTicketById(
                                    ticketId);

            if (ticket == null) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/ticket?action=browse");

                return;
            }

            if (!"AVAILABLE"
                    .equals(
                            ticket.getStatus())) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/ticket?action=browse");

                return;
            }

            Transfer transfer =
                    new Transfer();

            // Passenger details

            transfer.setPassengerName(

                    passengerName != null &&
                    !passengerName.trim()
                            .isEmpty()

                    ? passengerName

                    : "Unknown"
            );

            if (ageStr != null &&
                    !ageStr.trim()
                            .isEmpty()) {

                try {

                    transfer.setAge(
                            Integer.parseInt(
                                    ageStr));

                }

                catch (
                        NumberFormatException e) {

                    transfer.setAge(0);
                }

            } else {

                transfer.setAge(0);
            }

            transfer.setGender(

                    gender != null &&
                    !gender.trim()
                            .isEmpty()

                    ? gender

                    : "Unknown"
            );

            // Ticket details

            transfer.setTicketId(
                    ticketId);

            transfer.setSellerId(
                    ticket.getSellerId());

            transfer.setBuyerId(
                    user.getId());

            transfer.setPrice(
                    ticket.getPrice());

            transfer.setServiceFee(
                    ticket.getServiceFee());

            transfer.setTotalAmount(
                    ticket.getTotalAmount());

            transfer.setPaymentStatus(
                    "SUCCESS");

            boolean transferCreated =
                    transferDAO
                            .createTransfer(
                                    transfer);

            if (transferCreated) {

                ticketDAO
                        .markAsTransferred(
                                ticketId);

                response.sendRedirect(
                        request.getContextPath()
                                + "/buyer/my-purchases.jsp");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                                + "/ticket?action=browse");
            }

        }

        catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/ticket?action=browse");
        }
    }
}