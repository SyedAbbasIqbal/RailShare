<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%
String ticketId =
request.getParameter("ticketId");

String amount =
request.getParameter("amount");

String trainNumber =
request.getParameter("trainNumber");

String fromStation =
request.getParameter("fromStation");

String toStation =
request.getParameter("toStation");
%>

<!DOCTYPE html>
<html>

<head>
<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<meta charset="UTF-8">

<title>
Google Pay - RailShare
</title>

<style>

body{
font-family:Arial,sans-serif;
background:#e8eef7;
display:flex;
justify-content:center;
align-items:center;
min-height:100vh;
margin:0;
padding:20px;
}

.payment-card{
background:white;
width:420px;
padding:25px;
border-radius:25px;
box-shadow:0 4px 15px rgba(0,0,0,0.2);
text-align:center;
}

.gpay-logo img{
width:120px;
margin-bottom:15px;
}

.amount{
font-size:34px;
font-weight:bold;
margin-bottom:20px;
color:#202124;
}

.ticket-info{
background:#f8f9fa;
padding:15px;
border-radius:15px;
text-align:left;
margin-bottom:20px;
}

.ticket-info p{
margin:8px 0;
}

.qr-box{
margin:20px 0;
}

.qr-box img{
width:200px;
height:200px;
border-radius:15px;
border:1px solid #ddd;
}

.input-box{
margin-bottom:15px;
}

.input-box input,
.input-box select{
width:100%;
padding:14px;
border:1px solid #ccc;
border-radius:12px;
box-sizing:border-box;
font-size:15px;
}

.scan-box{
margin:15px 0;
font-size:14px;
text-align:left;
}

.pay-btn{
width:100%;
padding:16px;
border:none;
background:#1a73e8;
color:white;
font-size:18px;
border-radius:15px;
cursor:pointer;
font-weight:bold;
}

.loader{
display:none;
margin-top:20px;
font-size:18px;
font-weight:bold;
color:#1a73e8;
}

.success{
display:none;
margin-top:20px;
font-size:22px;
font-weight:bold;
color:green;
}

.error{
color:red;
margin-top:10px;
font-size:14px;
}

.note{
margin-top:15px;
font-size:12px;
color:gray;
}

</style>

<script>

function fakePayment(){

let passengerName =
document.getElementById(
"passengerName").value.trim();

let age =
document.getElementById(
"age").value.trim();

let gender =
document.getElementById(
"gender").value;

let upi =
document.getElementById(
"upiId").value.trim();

let scanned =
document.getElementById(
"scanQr").checked;

let error =
document.getElementById(
"error");

if(passengerName === "" ||
age === "" ||
gender === ""){

error.innerHTML =
"Enter passenger details";

return false;
}

if(upi === "" &&
!scanned){

error.innerHTML =
"Enter UPI ID or scan QR";

return false;
}

error.innerHTML = "";

// hidden values set
document.getElementById(
"hiddenPassengerName").value =
passengerName;

document.getElementById(
"hiddenAge").value =
age;

document.getElementById(
"hiddenGender").value =
gender;

document.getElementById(
"payBtn").style.display =
"none";

document.getElementById(
"loader").style.display =
"block";

setTimeout(function(){

document.getElementById(
"loader").style.display =
"none";

document.getElementById(
"success").style.display =
"block";

setTimeout(function(){

document.getElementById(
"paymentForm").submit();

},1500);

},4000);

return false;
}

</script>

</head>

<body>

<div class="payment-card">

<div class="gpay-logo">

<img src="${pageContext.request.contextPath}/images/gpay.png"
alt="Google Pay">

</div>

<div class="amount">

₹<%= amount %>

</div>

<div class="ticket-info">

<p>
<strong>Train:</strong>
<%= trainNumber %>
</p>

<p>
<strong>Route:</strong>
<%= fromStation %>
→
<%= toStation %>
</p>

</div>

<div class="input-box">

<input
type="text"
id="passengerName"
placeholder="Passenger Name">

</div>

<div class="input-box">

<input
type="number"
id="age"
placeholder="Age">

</div>

<div class="input-box">

<select id="gender">

<option value="">
Select Gender
</option>

<option value="Male">
Male
</option>

<option value="Female">
Female
</option>

<option value="Other">
Other
</option>

</select>

</div>

<div class="qr-box">

<img src="${pageContext.request.contextPath}/images/qr.JPG"
alt="QR Code">

</div>

<div class="input-box">

<input
type="text"
id="upiId"
placeholder="Enter UPI ID">

</div>

<div class="scan-box">

<input
type="checkbox"
id="scanQr">

I scanned QR code

</div>

<div
id="error"
class="error">
</div>

<form
id="paymentForm"
method="post"
action="${pageContext.request.contextPath}/transfer">

<input
type="hidden"
name="ticketId"
value="<%= ticketId %>">

<input
type="hidden"
name="passengerName"
id="hiddenPassengerName">

<input
type="hidden"
name="age"
id="hiddenAge">

<input
type="hidden"
name="gender"
id="hiddenGender">

<button
type="button"
id="payBtn"
class="pay-btn"
onclick="fakePayment()">

Pay ₹<%= amount %>

</button>

</form>

<div
id="loader"
class="loader">

⏳ Processing Payment...

</div>

<div
id="success"
class="success">

✅ Payment Successful

</div>

<div class="note">

Demo Payment • No real money deducted

</div>

</div>

</body>

</html>