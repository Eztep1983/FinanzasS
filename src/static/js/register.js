
document.addEventListener("DOMContentLoaded", function() {
    var form = document.querySelector(".form");
    form.addEventListener("submit", function(event) {
        var identificationInput = document.getElementById("identification");
        var passwordInput = document.getElementById("password");
        var confirm_passwordInput = document.getElementById("confirm_password");
        var fullnameInput = document.getElementById("fullname");
        // Limpiar los datos antes de enviar el formulario
        identificationInput.value = identificationInput.value.trim();
        passwordInput.value = passwordInput.value.trim();
        confirmPasswordInput.value = confirm_passwordInput.value.trim()
        fullnameInput.value =fullnameInput.value.trim()
    });
});

document.addEventListener("DOMContentLoaded", function() {
    // Obtener los elementos del DOM
    var passwordInput = document.getElementById("password");
    var confirmPasswordInput = document.getElementById("confirm_password");
    var passwordError = document.getElementById("password_error");

    // Agregar un evento keyup al input de contraseña
    passwordInput.addEventListener("keyup", function() {
        // Verificar si la longitud de la contraseña es suficiente
        if (passwordInput.value.length < 8) {
            passwordError.textContent = "La contraseña debe tener al menos 8 caracteres";
        } else {
            passwordError.textContent = "";
        }
    });

    // Agregar un evento keyup al input de confirmación de contraseña
    confirmPasswordInput.addEventListener("keyup", function() {
        // Verificar si las contraseñas coinciden
        if (confirmPasswordInput.value !== passwordInput.value) {
            passwordError.textContent = "Las contraseñas no coinciden";
        } else {
            passwordError.textContent = "";
        }
    });

    // Agregar evento click al botón de envío del formulario
    document.getElementById("añadir_user").addEventListener("click", function(event) {
        // Evita que el formulario se envíe automáticamente
        event.preventDefault();

        // Validar que todos los campos obligatorios estén llenos
        var identification = document.getElementById("identification").value.trim();
        var password = document.getElementById("password").value.trim();
        var confirm_password = document.getElementById("confirm_password").value.trim();
        var fullname = document.getElementById("fullname").value.trim();
        const namePattern = /^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/;
       
        if (identification === "" || password === "" || confirm_password === "" || fullname === "") {
            swal.fire({
                title: '¡Advertencia!',
                text: 'Por favor completa todos los campos para registrarte.',
                icon: 'warning',
                confirmButtonText: 'OK'
            });
        } else {
            // Mostrar confirmación y enviar el formulario si todos los campos están llenos
            swal.fire({
                title: '¡Se ha registrado al usuario!',
                icon: 'success',
                confirmButtonText: 'OK',
                showCancelButton: false
            }).then((result) => {
                // Envía manualmente el formulario solo si el usuario hizo clic en "OK"
                if (result.isConfirmed) {
                    document.getElementById("formulario_registro").submit();  // Envía el formulario con JavaScript
                }

            });
            if (!namePattern.test(fullname)) {
                swal.fire({
                    title: 'Error',
                    text: 'El nombre solo debe contener letras y espacios.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
                return;
            }
            if (password.includes(" ")) {
                swal.fire({
                    title: 'Error',
                    text: 'La contraseña no debe contener espacios.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
                return;
            } 
        }
    });
});