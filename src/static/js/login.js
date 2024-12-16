document.querySelector(".form").addEventListener("submit", function(event) {
    var identification = document.getElementById("identification").value.trim();
    var password = document.getElementById("password").value.trim();
    

    if (identification === "" || password === "") {
        event.preventDefault();
        swal.fire({
            title: 'Error',
            text: 'Por favor complete todos los campos..',
            icon: 'error',
            confirmButtonText: 'OK'
        });
    }
});

// Sanitización en el cliente
document.addEventListener("DOMContentLoaded", function() {
    var form = document.querySelector(".form");
    form.addEventListener("submit", function(event) {
        var identificationInput = document.getElementById("identification");
        var passwordInput = document.getElementById("password");
        // Limpiar los datos antes de enviar el formulario
        identificationInput.value = identificationInput.value.trim();
        passwordInput.value = passwordInput.value.trim();
    });
});