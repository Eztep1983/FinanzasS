from flask_mysqldb import MySQL
from config import config
import logging

mysql = MySQL()

class Aportador:
    def __init__(self, id_usuario, nombre, correo, telefono, fecha_registro, aporte_mensual):
        self.id_usuario=id_usuario
        self.nombre= nombre
        self.correo= correo
        self.telefono= telefono
        self.fecha_registro=fecha_registro
        self.aporte_mensual=aporte_mensual
        
        
    def lista_aportadores():
        try:
            conn= mysql.connection
            cursor= conn.cursor()
            sql = """
                    SELECT id_usuario, nombre, correo, telefono, fecha_registro, aporte_mensual FROM aportadores
                  """
            cursor.execute(sql)
            aportadores= []
            for row in cursor.fetchall():
                id_usuario, nombre, correo, telefono, fecha_registro, aporte_mensual = row
                aportador = Aportador(id_usuario, nombre, correo, telefono, fecha_registro, aporte_mensual)
                aportadores.append(aportador)
                cursor.close()
        except Exception as e:
            conn.rollback()
            print("Error al obtener la lista de aportadores", str(e))
            
            
    def añadir_aportador():
        try: 
            conn= mysql.connection
            cursor= conn.cursor()
            sql = """
                    INSERT INTO aportadores ()
                  """
        except Exception as e:
            print("Error al añadir el aportador",str(e)) 
    def eliminar_aportador():
        pass
    def actualizar_aportador():
        pass   