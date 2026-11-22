// RailShare - Client-side Validation

/**
 * Validate train number (exactly 5 digits)
 */
function validateTrainNumber(trainNumber) {
    const pattern = /^\d{5}$/;
    if (!pattern.test(trainNumber)) {
        return {
            valid: false,
            message: "Train number must be exactly 5 digits"
        };
    }
    return { valid: true };
}

/**
 * Validate PNR (exactly 10 digits)
 */
function validatePNR(pnr) {
    const pattern = /^\d{10}$/;
    if (!pattern.test(pnr)) {
        return {
            valid: false,
            message: "PNR must be exactly 10 digits"
        };
    }
    return { valid: true };
}

/**
 * Validate date is not in the past
 */
function validateDate(dateStr) {
    const selectedDate = new Date(dateStr);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    if (selectedDate < today) {
        return {
            valid: false,
            message: "Travel date cannot be in the past"
        };
    }
    return { valid: true };
}

/**
 * Validate travel time is at least 6 hours from now
 */
function validateTravelTime(dateStr, timeStr) {
    if (!dateStr || !timeStr) {
        return { valid: true }; // Let server handle this
    }
    
    const travelDateTime = new Date(dateStr + 'T' + timeStr);
    const now = new Date();
    const hoursDifference = (travelDateTime - now) / (1000 * 60 * 60);
    
    if (hoursDifference < 6) {
        return {
            valid: false,
            message: "Ticket must be listed at least 6 hours before travel time"
        };
    }
    return { valid: true };
}

/**
 * Validate ticket listing form
 */
function validateTicketForm() {
    const trainNumber = document.getElementById('trainNumber').value.trim();
    const pnr = document.getElementById('pnr').value.trim();
    const travelDate = document.getElementById('travelDate').value;
    const travelTime = document.getElementById('travelTime').value;
    
    // Validate train number
    const trainValidation = validateTrainNumber(trainNumber);
    if (!trainValidation.valid) {
        showError(trainValidation.message);
        document.getElementById('trainNumber').focus();
        return false;
    }
    
    // Validate PNR
    const pnrValidation = validatePNR(pnr);
    if (!pnrValidation.valid) {
        showError(pnrValidation.message);
        document.getElementById('pnr').focus();
        return false;
    }
    
    // Validate date
    if (travelDate) {
        const dateValidation = validateDate(travelDate);
        if (!dateValidation.valid) {
            showError(dateValidation.message);
            document.getElementById('travelDate').focus();
            return false;
        }
    }
    
    // Validate travel time (6-hour rule)
    if (travelDate && travelTime) {
        const timeValidation = validateTravelTime(travelDate, travelTime);
        if (!timeValidation.valid) {
            showError(timeValidation.message);
            return false;
        }
    }
    
    return true;
}

/**
 * Real-time validation for train number input
 */
function setupTrainNumberValidation() {
    const trainNumberInput = document.getElementById('trainNumber');
    if (trainNumberInput) {
        trainNumberInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value && !/^\d{0,5}$/.test(value)) {
                this.value = value.slice(0, 5).replace(/\D/g, '');
            }
        });
        
        trainNumberInput.addEventListener('blur', function() {
            const validation = validateTrainNumber(this.value.trim());
            if (!validation.valid) {
                showFieldError(this, validation.message);
            } else {
                clearFieldError(this);
            }
        });
    }
}

/**
 * Real-time validation for PNR input
 */
function setupPNRValidation() {
    const pnrInput = document.getElementById('pnr');
    if (pnrInput) {
        pnrInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value && !/^\d{0,10}$/.test(value)) {
                this.value = value.slice(0, 10).replace(/\D/g, '');
            }
        });
        
        pnrInput.addEventListener('blur', function() {
            const validation = validatePNR(this.value.trim());
            if (!validation.valid) {
                showFieldError(this, validation.message);
            } else {
                clearFieldError(this);
            }
        });
    }
}

/**
 * Show error message
 */
function showError(message) {
    // Remove existing alerts
    const existingAlert = document.querySelector('.alert-error');
    if (existingAlert) {
        existingAlert.remove();
    }
    
    // Create new alert
    const alert = document.createElement('div');
    alert.className = 'alert alert-error';
    alert.textContent = message;
    
    // Insert at top of form
    const form = document.querySelector('form');
    if (form) {
        form.insertBefore(alert, form.firstChild);
    }
}

/**
 * Show field-specific error
 */
function showFieldError(field, message) {
    clearFieldError(field);
    field.style.borderColor = '#dc3545';
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.style.color = '#dc3545';
    errorDiv.style.fontSize = '12px';
    errorDiv.style.marginTop = '5px';
    errorDiv.textContent = message;
    field.parentNode.appendChild(errorDiv);
}

/**
 * Clear field error
 */
function clearFieldError(field) {
    field.style.borderColor = '';
    const errorDiv = field.parentNode.querySelector('.field-error');
    if (errorDiv) {
        errorDiv.remove();
    }
}

/**
 * Initialize validation on page load
 */
document.addEventListener('DOMContentLoaded', function() {
    setupTrainNumberValidation();
    setupPNRValidation();
    
    // Setup form submission validation
    const ticketForm = document.getElementById('ticketForm');
    if (ticketForm) {
        ticketForm.addEventListener('submit', function(e) {
            if (!validateTicketForm()) {
                e.preventDefault();
                return false;
            }
        });
    }
});
