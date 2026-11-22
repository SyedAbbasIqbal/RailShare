package com.railshare.controller;

import java.io.IOException;
import java.awt.Color;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import com.railshare.dao.TicketDAO;
import com.railshare.dao.TransferDAO;
import com.railshare.model.Ticket;
import com.railshare.model.Transfer;
import com.railshare.model.User;

@WebServlet("/download-ticket")
public class DownloadTicketServlet
        extends HttpServlet {

    private static final long
            serialVersionUID = 1L;

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
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)

            throws ServletException,
            IOException {

        HttpSession session =
                request.getSession(false);

        if(session == null ||
                session.getAttribute(
                        "user")
                        == null){

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp");

            return;
        }

        User user =
                (User) session
                        .getAttribute(
                                "user");

        String ticketIdStr =
                request.getParameter(
                        "ticketId");

        if(ticketIdStr == null){

            response.sendRedirect(
                    request.getContextPath()
                            + "/buyer/my-purchases.jsp");

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

            if(ticket == null){

                response.sendRedirect(
                        request.getContextPath()
                                + "/buyer/my-purchases.jsp");

                return;
            }

            Transfer transfer = null;

            if("ADMIN".equals(
                    user.getRole())){

                for(Transfer t
                        : transferDAO
                        .getAllTransfers()){

                    if(t.getTicketId()
                            == ticketId){

                        transfer = t;
                        break;
                    }
                }

            }else{

                for(Transfer t
                        : transferDAO
                        .getTransfersByBuyer(
                                user.getId())){

                    if(t.getTicketId()
                            == ticketId){

                        transfer = t;
                        break;
                    }
                }
            }

            if(transfer == null){

                response.sendRedirect(
                        request.getContextPath()
                                + "/buyer/my-purchases.jsp");

                return;
            }

            response.setContentType(
                    "application/pdf");

            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=RailShare_Ticket.pdf");

            Document document =
                    new Document();

            PdfWriter.getInstance(
                    document,
                    response
                            .getOutputStream());

            document.open();

            Font titleFont =
                    new Font(
                            Font.HELVETICA,
                            22,
                            Font.BOLD,
                            Color.BLUE);

            Font headingFont =
                    new Font(
                            Font.HELVETICA,
                            16,
                            Font.BOLD);

            Font normalFont =
                    new Font(
                            Font.HELVETICA,
                            13);

            Paragraph title =
                    new Paragraph(
                            "RAILSHARE E-TICKET",
                            titleFont);

            title.setAlignment(
                    Element.ALIGN_CENTER);

            document.add(title);

            document.add(
                    new Paragraph(
                            " "));

            document.add(
                    new Paragraph(
                            "Passenger Details",
                            headingFont));

            document.add(
                    new Paragraph(
                            "Name: "
                                    + transfer.getPassengerName(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Age/Gender: "
                                    + transfer.getAge()
                                    + " / "
                                    + transfer.getGender(),
                            normalFont));

            document.add(
                    new Paragraph(
                            " "));

            document.add(
                    new Paragraph(
                            "Journey Details",
                            headingFont));

            document.add(
                    new Paragraph(
                            "Train Number: "
                                    + ticket.getTrainNumber(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "PNR: "
                                    + ticket.getPnr(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Route: "
                                    + ticket.getFromStation()
                                    + " → "
                                    + ticket.getToStation(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Travel Date: "
                                    + ticket.getTravelDate(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Travel Time: "
                                    + ticket.getTravelTime(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Coach: "
                                    + ticket.getCoachNo(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Seat Number: "
                                    + ticket.getSeatNo(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Berth: "
                                    + ticket.getSeatType(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Class: "
                                    + ticket.getTicketClass(),
                            normalFont));

            document.add(
                    new Paragraph(
                            " "));

            document.add(
                    new Paragraph(
                            "Payment Details",
                            headingFont));

            document.add(
                    new Paragraph(
                            "Amount Paid: ₹"
                                    + transfer.getTotalAmount(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Payment Status: "
                                    + transfer.getPaymentStatus(),
                            normalFont));

            document.add(
                    new Paragraph(
                            "Transfer Date: "
                                    + transfer.getTransferDate(),
                            normalFont));

            document.add(
                    new Paragraph(
                            " "));

            Paragraph footer =
                    new Paragraph(
                            "This is a digitally generated RailShare ticket.",
                            normalFont);

            footer.setAlignment(
                    Element.ALIGN_CENTER);

            document.add(
                    footer);

            document.close();

        }

        catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/buyer/my-purchases.jsp");
        }
    }
}