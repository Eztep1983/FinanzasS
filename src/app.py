from flask import Flask, abort, render_template, redirect, url_for, request, flash
from flask_mysqldb import MySQL
from flask_wtf import CSRFProtect
from flask_login import LoginManager, login_user, logout_user, login_required, current_user
from models.ModelUser import ModelUser 
from models.register import *
from models.entities.user import User
import os
from config import config

#Ejecutar la API
app = Flask(__name__)

# Configuración de la base de datos y del login manager
app.config.from_object(config['development'])
db = MySQL(app)
csrf = CSRFProtect(app)
login_manager_app = LoginManager(app)
login_manager_app.login_view = 'login'

# Inicialización de la protección CSRF
csrf.init_app(app)

@app.after_request
def no_cache(response):
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
    return response

#_______________________________________________________________________________________________________
#PARA ELIMINAR EL CACHE

@app.after_request
def no_cache(response):
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
    return response

#_______________________________________________________________________________________________________
#RUTA LOGIN
@app.route('/')
def index():
    """
    Redirige automáticamente a la ruta de inicio de sesión por defecto.

    Flujo:
        1. Llama a la función `login` utilizando `url_for`.
        2. Redirige al usuario a la página de inicio de sesión.

    Returns:
        - Redirección a la vista de inicio de sesión.
    """
    return redirect(url_for('login')) #Redireccion directa a login

@login_manager_app.user_loader
def load_user(id):
    """
    Carga un usuario específico en base a su ID.

    Flujo:
        1. Utiliza el ID proporcionado por Flask-Login.
        2. Llama a la función `get_by_id` del modelo `ModelUser` para recuperar los datos del usuario desde la base de datos.

    Returns:
        - Una instancia del usuario si se encuentra, o `None` si no se encuentra.
    """
    return ModelUser.get_by_id(db, id)

#RUTA PARA CERRAR SESION
@app.route('/logout')
@login_required
def logout():
    """
    Cierra la sesión del usuario actual y redirige a la página de cierre de sesión.

    Flujo:
        1. Llama a `logout_user` para finalizar la sesión del usuario.
        2. Redirige al usuario a la página de cierre de sesión definida por la función `logout`.

    Returns:
        - Redirección a la vista de cierre de sesión.
    """
    logout_user()
    return redirect(url_for('login'))

#_______________________________________________________________________________________________________
                                                #Login
@app.route('/login', methods=["GET", "POST"])
def login():
    """
    Maneja el inicio de sesión de los usuarios.

    Métodos permitidos:
        - GET: Renderiza la página de inicio de sesión.
        - POST: Procesa el formulario de inicio de sesión.

    Flujo del método POST:
        1. Valida que los campos `identification` y `password` no estén vacíos.
        2. Crea una instancia temporal de usuario (`User`) con los datos ingresados.
        3. Busca al usuario en la base de datos mediante `ModelUser.login`.
        4. Si el usuario es encontrado:
            - Verifica si la contraseña proporcionada es correcta usando `User.check_password`.
            - Si la contraseña es válida, inicia sesión y redirige a la página principal.
            - Si la contraseña es inválida, muestra un mensaje de error.
        5. Si el usuario no es encontrado, muestra un mensaje de error.

    Returns:
        - GET: Renderiza el template `auth/login.html`.
        - POST: Dependiendo de la validación:
            - Redirige a la página principal si las credenciales son válidas.
            - Renderiza `auth/login.html` con un mensaje de error si hay fallas en la autenticación.
    """
    if request.method == 'POST':
        identification = request.form.get('identification')
        password = request.form.get('password')

        # Validar campos
        if not identification or not password:
            flash("Por favor, completa todos los campos", "warning")
            return render_template('/login.html')

        # instancia temporal de User
        temp_user = User(0, identification, password)

        # Buscar usuario en la base de datos
        logged_user = ModelUser.login(db, temp_user)

        if logged_user:
            # Verificar la contraseña
            if User.check_password(logged_user.password, password):
                login_user(logged_user)
                return redirect(url_for('home'))
            else:
                flash("Contraseña inválida", "danger")
        else:
            flash("Usuario no encontrado", "danger")
    return render_template('auth/login.html')

#_______________________________________________________________________________________________________
                                            #Registro de usuarios
#RUTA PARA EL REGISTRO DE USUARIOS
@app.route('/register', methods=["GET", "POST"])
def register():
    """
    Maneja el registro de nuevos usuarios.

    Métodos permitidos:
        - GET: Renderiza la página de registro.
        - POST: Procesa el formulario para registrar un nuevo usuario.

    Flujo del método POST:
        1. Valida que los campos `identification`, `password` y `fullname` no estén vacíos.
        2. Crea un objeto `User` con los datos proporcionados.
        3. Intenta registrar al usuario en la base de datos utilizando `Register.register`.
        4. Si el registro es exitoso, redirige a la página de inicio de sesión.
        5. Maneja posibles errores:
            - `ValueError`: Mensaje de advertencia específico.
            - Otros errores: Mensaje genérico de error y redirección a la página de registro.

    Manejo de excepciones:
        - Captura errores inesperados y muestra un mensaje de error en la página de registro.

    Returns:
        - GET: Renderiza el template `auth/register.html`.
        - POST: Redirige al login si el registro es exitoso o vuelve al formulario con mensajes de error.
    """
    try:
        if request.method == 'POST':
            identification = request.form.get('identification')
            password = request.form.get('password')
            fullname = request.form.get('fullname')

            if not identification or not password or not fullname:
                flash("Por favor, completa todos los campos", "warning")
                return render_template('auth/register.html')

            # Crear objeto User
            user = User(None, identification, password, fullname)

            try:
                registered_user = Register.register(db, user)
                return redirect(url_for('login'))
            except ValueError as ve:
                flash(str(ve), "warning")
            except Exception as e:
                flash("Error al registrar usuario", "danger")
                return redirect(url_for('register'))

        return render_template('auth/register.html')
    except Exception as e:
        flash(f"Error inesperado: {str(e)}", "danger")
        return render_template('auth/login.html')
    
    
#RUTA PARA EL HOME
@app.route('/home')
@login_required 
def home():
    return render_template('home.html')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
