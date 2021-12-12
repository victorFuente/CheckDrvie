from flask import Flask, render_template, request, redirect, url_for, flash, session, Response
from flask_mysqldb import MySQL
from flask_bcrypt import bcrypt
from flask_mail import Mail, Message
#nuevas librerias ##Response
import io
import xlwt
import time
import datetime

from logging import log
##validacion de patente
#guardar imagen
from werkzeug.utils import secure_filename
import os
#eliminar imagen
from os import remove
#lectura de patente
import cv2
import pytesseract
#modificar el tamaño de la imagen
import imutils
#para reemplazar caracteres
import re
import numpy as np
#token
import uuid

app = Flask(__name__)
#conexion a mysql
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD '] = ''
app.config['MYSQL_DB'] = 'check'
mysql = MySQL(app)

#configuracion correo
app.config['MAIL_SERVER']='smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = 'checkdrive9@gmail.com'
app.config['MAIL_PASSWORD'] = 'Enero.2021'
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True

mail = Mail(app)

# SEMILLA PARA ENCRIPTAR LA CONTRASEÑA
semilla = bcrypt.gensalt()

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract'

# contraseña de la session
app.secret_key = 'clavemitica'

# RUTA DE INICIO
@app.route('/')
def Index():
        if 'nombre' in session:
          
           id_permiso = session['id_permiso']
           if (id_permiso == 1):
              
              return redirect(url_for('IndexAdmin'))

           elif (id_permiso == 2):
              
              return redirect(url_for('IndexMinera')) 

           elif (id_permiso == 3):
              
              return redirect(url_for('IndexPrestador'))

           elif (id_permiso == 4):
              
              return redirect(url_for('IndexGuardia'))

           else:           
              return render_template('index.html')    
        else: 
          session.clear()            
          return render_template('index.html')

# RUTA DE INICIO
@app.route('/inicioSesion')
def InicioSesion():
        if 'nombre' in session:
          
           id_permiso = session['id_permiso']
           if (id_permiso == 1):
              
              return redirect(url_for('IndexAdmin'))

           elif (id_permiso == 2):
              
              return redirect(url_for('IndexMinera')) 

           elif (id_permiso == 3):
              
              return redirect(url_for('IndexPrestador'))

           elif (id_permiso == 4):
              
              return redirect(url_for('IndexGuardia'))

           else:           
              return render_template('login.html')    
        else: 
          session.clear()            
          return render_template('login.html')
          

# RUTA DE error 404
@app.route('/404')
def Error(): 

       if 'nombre' in session:
          # carga vista de index
          return render_template('404.html')
       else:
          return render_template('login.html')

 

# RUTA DE construccion
@app.route('/blank')
def Blank():
    return render_template('blank.html')

################################################## INICIO SESION ###########################################################3
# RUTA DE LOGIN (Inicio de sesion)
@app.route('/login', methods=[ "POST"])
def Login():
    if request.method=='POST':

      correo = request.form['emailLogin']
      password = request.form['passwordLogin']
      password_encode = password.encode("utf-8")

      # creo cursor para ejecucion de query
      cur = mysql.connection.cursor()
      # preparo la query para la consulta
      # Query = "SELECT nombre, correo, password FROM empleados WHERE correo = %s"
      Query = "SELECT nombre, correo, password, permiso.id_permiso, id_empleado, id_empresa, id_prestador FROM empleados INNER JOIN permiso ON empleados.id_permiso = permiso.id_permiso  WHERE correo = %s"
      # se ejecuta la query
      cur.execute(Query, [correo])
      #obtengo dato
      usuario = cur.fetchone()
      # cierro consulta

      # VERIFICO SI SE OBTUVO DATOS
      if (usuario != None):
        # obtengo la password encriptada
        password_encriptado_encode = usuario[2].encode()
        id_empleado = usuario[3]

        if (bcrypt.checkpw(password_encode, password_encriptado_encode)):
            
            #captura de inicio de sesion auditoria_usuario
            session['nombre'] = usuario[0]
            session['id_empleado'] = usuario[4]
            session['id_empresa'] = usuario[5]
            session['id_prestador'] = usuario[6]
            ts = time.time()
            timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
            cur = mysql.connection.cursor()
            cur.execute('INSERT INTO auditoria_usuario (nombre,tipo,fecha_hora) VALUES (%s, %s, %s)',
            (usuario[0], 'entrada', timestamp))
            mysql.connection.commit()
            # registro la sesion
            if (id_empleado == 1):

              session['nombre'] = usuario[0]
              session['id_permiso'] = usuario[3]
              return redirect(url_for('IndexAdmin'))

            elif (id_empleado == 2):
              session['nombre'] = usuario[0]
              session['id_permiso'] = usuario[3]
              return redirect(url_for('IndexMinera'))
            
            elif (id_empleado == 3):
              session['nombre'] = usuario[0]
              session['id_permiso'] = usuario[3]
              return redirect(url_for('IndexPrestador'))
              

            elif (id_empleado == 4):
              session['nombre'] = usuario[0]
              session['id_permiso'] = usuario[3]
              return render_template('Usuario_index.html')

            else:
              flash("¡Datos ingresados incorrectamente!", "alert-danger")
              return render_template('login.html')
            
        else:
            # mensaje
            flash("¡Datos ingresados incorrectamente!", "alert-danger")
            return render_template('login.html')
      else:
        flash("Ingrese correo y contraseña", "alert-danger")
        # return redirect(url_for('/'))
        return render_template('login.html')

#cierre la sesion
@app.route('/salir')
def Salir():
  ts = time.time()
  timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
  cur = mysql.connection.cursor()
  cur.execute('INSERT INTO auditoria_usuario (nombre,tipo,fecha_hora) VALUES (%s, %s, %s)',
  (session['nombre'], 'salida', timestamp))
  mysql.connection.commit()
  # limpiar la sesion
  session.clear()
  if 'nombre' in session:
    #carga vista de index
    cur = mysql.connection.cursor()
    cur.execute('Select * from empresa where habilitado = 1')
    data = cur.fetchall()
    return render_template('index.html', empresas = data)
  else:                 
    return render_template('index.html')

################################################### CIERRA SESSION ######################################################

################################################### INICIA ADMIN ###############################################################

################################################### EMPRESA #############################################################

#INDEX administrador 
@app.route('/admin')
def IndexAdmin():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute('Select count(id_empresa) from empresa where habilitado = 1')
    data = cur.fetchall()
    cur.execute('Select count(id_empleado) from empleados where habilitado = 1')
    data2 = cur.fetchall()
    cur.execute('Select count(id_prestador) from prestador where habilitado = 1')
    data3 = cur.fetchall()
    cur.execute('Select count(id_activo) from activos where habilitado = 1')
    data4 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_index.html', empresas = data, usuarios = data2, prestadores = data3, activos = data4, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html')


# Lista las empresas creadas
@app.route('/listar_empresa')
def listar_empresa():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute('Select * from empresa where habilitado = 1')
    data = cur.fetchall() 
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_agregar_empresa.html', empresas = data, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html')

# Crea empresas (MINERAS)
@app.route('/add_empresa' ,methods=['POST'])
def add_empresa():
    if request.method == 'POST':
        rut = request.form['rut']
        nombre = request.form['nombre']
        telefono = request.form['telefono']
        correo = request.form['correo']
        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO empresa (rut,nombre,telefono,correo,habilitado, id_usuario) VALUES (%s, %s, %s, %s,%s, %s)',
         (rut,nombre,telefono,correo,1, session['id_empleado']))
        mysql.connection.commit()
        flash('empresa agregada')
        return redirect(url_for('listar_empresa'))

# Selecciono empresa a editar
@app.route('/edit_empresa/<id>')
def get_empresa(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM empresa WHERE id_Empresa = {0}'.format(id))
    data = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_edit_empresa.html', empresas = data[0], contadores = data5, alertas = data6)

# Modifico la empresa seleccionada
@app.route('/update_empresa/<id>', methods = ['POST'])
def update_empresa(id):
    if (request.method == 'POST'):
        rut = request.form['rut']
        nombre = request.form['nombre']
        telefono = request.form['telefono']
        correo = request.form['correo']
        cur = mysql.connection.cursor()
        cur.execute("""
        UPDATE empresa 
        SET rut = %s,
            nombre = %s,
            telefono = %s,
            Correo = %s,
            id_usuario = %s
            WHERE id_Empresa = %s""",
            (rut, nombre, telefono, correo, session['id_empleado'], id))
        mysql.connection.commit()    
        # flash('empresa modificada')
        return redirect(url_for('listar_empresa'))

#Elimino empresa
@app.route('/delete_empresa/<string:id>')
def delete_empresa(id):
    cur = mysql.connection.cursor()
    #cur.execute('UPDATE empresa SET habilitado = 0 WHERE id_Empresa = {0}'.format(id))
    cur.execute('UPDATE empresa SET habilitado = %s,id_usuario = %s WHERE id_Empresa = %s', (0,  session['id_empleado'], id))
    mysql.connection.commit()
    flash('Empresa eliminada')
    return redirect(url_for('listar_empresa')) 


########################################################## PRESTADOR ###################################################3

# Lista los prestadores creados
@app.route('/listar_prestador')
def listar_prestador():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute('Select * from prestador where habilitado = 1')
    data = cur.fetchall()
    cur.execute('Select * from empresa where habilitado = 1')
    dataEmpresa = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_agregar_prestador.html', prestador = data, empresas = dataEmpresa, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html') 


#Crea prestadores
@app.route('/add_prestador' ,methods=['POST'])
def add_prestador():
    if request.method == 'POST':
        rut = request.form['rut']
        nombre = request.form['nombre']
        telefono = request.form['telefono']
        correo = request.form['correo']
        direccion = request.form['direccion']
        empresa = request.form['empresa']
        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO prestador (rut,nombre,telefono,correo,direccion,habilitado, id_usuario, id_empresa) VALUES (%s, %s, %s, %s,%s,%s,%s,%s)',
         (rut,nombre,telefono,correo,direccion,1, session['id_empleado'],empresa))
        mysql.connection.commit()
        flash('prestador agregada')
        return redirect(url_for('listar_prestador'))

#Selecciona al prestador a modificar
@app.route('/edit_prestador/<id>')
def get_prestador(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM prestador WHERE id_prestador = {0}'.format(id))
    data = cur.fetchall()
    cur.execute('Select * from empresa where habilitado = 1')
    dataEmpresa = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('SELECT count(id_activo),patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_edit_prestador.html', prestadores = data[0], empresas = dataEmpresa, contadores = data5, alertas =data6)

# Modifica prestador
@app.route('/update_prestador/<id>', methods = ['POST'])
def update_prestador(id):
    if request.method == 'POST':
        rut = request.form['rut']
        nombre = request.form['nombre']
        telefono = request.form['telefono']
        correo = request.form['correo']
        direccion = request.form['direccion']
        empresa = request.form['empresa']
        cur = mysql.connection.cursor()
        cur.execute("""
        UPDATE prestador 
        SET rut = %s,
        nombre = %s,
        telefono = %s,
        correo = %s,
        direccion = %s,
        id_usuario = %s,
        id_empresa = %s
        WHERE id_prestador = %s"""
        , (rut, nombre, telefono, correo, direccion, session['id_empleado'], empresa, id))
        mysql.connection.commit()
        # flash('Prestador modificado')
        return redirect(url_for('listar_prestador'))



#elimina prestador
@app.route('/delete_prestador/<string:id>')
def delete_prestador(id):
    cur = mysql.connection.cursor()
    #cur.execute('UPDATE prestador SET habilitado = 0 WHERE id_prestador = {0}'.format(id))
    cur.execute('UPDATE prestador SET habilitado = %s,id_usuario = %s WHERE id_prestador = %s', (0,  session['id_empleado'], id))
    mysql.connection.commit()
    flash('prestador eliminado')
    return redirect(url_for('listar_prestador'))    


######################################################### ACTIVOS ############################################################

# Lista los activos
@app.route('/listar_activo')
def listar_activo():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    ##cur.execute('Select * from activos where habilitado = 1')
    cur.execute('Select a.id_activo, a.patente, a.tipo_vehiculo, a.marca, a.modelo, a.fecha_rev_tec, a.fecha_perm_circ, e.nombre, p.nombre from activos a INNER JOIN empresa e on e.id_empresa = a.id_empresa INNER JOIN prestador p on p.id_prestador = a.id_prestador where a.habilitado = 1')
    data = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('Select * from empresa where habilitado = 1')
    dataEmpresa = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('Select * from prestador where habilitado = 1')
    dataPrestador = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_agregar_activo.html', activos = data, empresas= dataEmpresa, prestadores = dataPrestador, contadores = data5, alertas= data6)
  else:                 
    return render_template('login.html')    

#@app.route('/proveedor')
#def IndexProveedor():
#    cur = mysql.connection.cursor()
#    cur.execute('Select * from activos where habilitado = 1')
#    data = cur.fetchall()
#    return render_template('indexPrestador.html', activos = data)


# Crea activos
@app.route('/add_activo' , methods=['POST'])
def add_activo():
    if request.method == 'POST':

        patente = request.form['patente']
        tipo_vehiculo = request.form['tipo_vehiculo']
        marca = request.form['marca']
        modelo = request.form['modelo']
        numero_motor = request.form['numero_motor']
        chasis = request.form['chasis']
        color = request.form['color']
        anio = request.form['año']
        fecha_rev_tec = request.form['fecha_rev_tec']
        fecha_perm_circ = request.form['fecha_perm_circ']
        combustible = request.form['combustible']
        transmision = request.form['transmision']
        empresa = request.form['empresa'] if request.form['empresa'] != '0' else None
        proveedor = request.form['proveedor'] if request.form['proveedor'] != '0' else None
        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador, id_usuario) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, 1, empresa, proveedor, session['id_empleado']))
        mysql.connection.commit()
        flash('activos agregada')
        return redirect(url_for('listar_activo'))

#selecciono activo a editar
@app.route('/edit_activo/<id>')
def get_activo(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM activos WHERE id_activo = %s', [id])
    data = cur.fetchall()
    cur.execute('SELECT count(id_activo),patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_edit_activo.html', activos = data[0], contadores = data5, alertas = data6)

#Edito activo
@app.route('/update_activo/<id>', methods = ['POST'])
def update_activo(id):
    if request.method == 'POST':
        patente = request.form['patente']
        tipo_vehiculo = request.form['tipo_vehiculo']
        marca = request.form['marca']
        modelo = request.form['modelo']
        numero_motor = request.form['numero_motor']
        chasis = request.form['chasis']
        color = request.form['color']
        anio = request.form['año']
        fecha_rev_tec = request.form['fecha_rev_tec']
        fecha_perm_circ = request.form['fecha_perm_circ']
        combustible = request.form['combustible']
        transmision = request.form['transmision']
        cur = mysql.connection.cursor()
        # cur.execute(""" UPDATE activos SET patente = %s, tipo_vehiculo = %s, WHERE id_activo = %s""", (patente, tipo_vehiculo, id))
        cur.execute("""
            UPDATE activos 
            SET patente = %s,
                tipo_vehiculo = %s,
                marca = %s,
                modelo = %s,
                numero_motor = %s,
                chasis = %s,
                color = %s,
                anio = %s,
                fecha_rev_tec = %s,
                fecha_perm_circ = %s,
                combustible = %s,
                transmision = %s,
                id_usuario = %s
            WHERE id_activo = %s  
        """, (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, session['id_empleado'], id))
        mysql.connection.commit()
        # flash('Prestador modificado')
        return redirect(url_for('listar_activo'))

#Elimino Activo
@app.route('/delete_activo/<string:id>')
def delete_activo(id):
    cur = mysql.connection.cursor()
    #cur.execute('UPDATE activos SET habilitado = 0 WHERE id_activo = {0}'.format(id))
    cur.execute('UPDATE activos SET habilitado = %s,id_usuario = %s WHERE id_activo = %s', (0,  session['id_empleado'], id))
    mysql.connection.commit()
    flash('prestador eliminado')
    return redirect(url_for('listar_activo'))



####################################################### USUARIOS ###########################################################

#Lista los usuarios creados
@app.route('/listar_usuario')
def listar_usuario():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute('Select * from empleados where habilitado = 1')
    data = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('Select * from empresa where habilitado = 1')
    datos = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_agregar_usuario.html', empresas = datos, empleados = data, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html')




##############################################################################################################################

#Lista las empresas para ser asignadas a un usuario
@app.route('/FormRegistro')
def FormRegistro():
  cur = mysql.connection.cursor()
  cur.execute('Select * from empresa where habilitado = 1')
  data = cur.fetchall()
  return render_template('agregar_usuario.html', empresas = data)


# RUTA PARA REGISTRAR USUARIOS
@app.route('/registro', methods = ["GET", "POST"])
def Registro():

  if (request.method=='POST'):
    
     # VERIFICA QUE HAYA UNA SESION ACTIVA
    #  if 'nombre' in session:
    #    # carga vista de index
    #           cur = mysql.connection.cursor()
    #           cur.execute('Select * from empresa where habilitado = 1')
    #           data = cur.fetchall()
    #           return render_template('index.html', empresas = data)
    #  else:
    #    # carga vista de login 
    #    return render_template('login.html')

   #else:
  # OBTENGO LOS DATOS DEL FORMULARIO REGISTRO
    rut = request.form['rut']
    nombre = request.form['nombre']
    apellido_paterno = request.form['apellido_paterno']
    apellido_materno = request.form['apellido_materno']
    telefono = request.form['telefono']
    direccion = request.form['direccion']
    rol = request.form['rol']  
    correo = request.form['correo']
    password = request.form['password']
    id_permiso = int(rol)
    password_encode = password.encode("utf-8")
    id_empresa = request.form['empresa']
    password_encriptado = bcrypt.hashpw(password_encode, semilla)
    #QUERY PARA INSERCION DE LOS DATOS EN LA TABLA
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO empleados (rut, nombre, apellido_paterno, apellido_materno, telefono, direccion, rol, correo, password, id_permiso, id_empresa, habilitado, id_usuario) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', ((rut, nombre, apellido_paterno, apellido_materno, telefono, direccion, rol, correo, password_encriptado, id_permiso, id_empresa, 1, session['id_empleado'])))
    mysql.connection.commit()
    # # Registro la sesion
    # session['nombre'] = nombre
    # # session['email'] = email
    # RETORNO AL LOGIN PARA QUE INGRESE EL USUARIO REGISTRADO
    return redirect(url_for('listar_usuario'))

#Selecciono el usuario a editar
@app.route('/edit_usuario/<id>')
def get_edit_usuario(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM empleados WHERE id_empleado = {0}'.format(id))
    data = cur.fetchall()
    cur.execute('SELECT count(id_activo),patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_edit_usuario.html', empleados = data[0], contadores = data5, alertas = data6)

# Actualizar Usuario
@app.route('/update_empleado/<id>',  methods = ['POST'])
def update_usuario(id):
    if (request.method == 'POST'):
        rut = request.form['rut']
        nombre = request.form['nombre']
        apellido_paterno = request.form['apellido_paterno']
        apellido_materno = request.form['apellido_materno']
        telefono = request.form['telefono']
        direccion = request.form['direccion']
        rol = request.form['rol']
        correo = request.form['correo']
        password = request.form['password']
        password_encode = password.encode("utf-8")
        password_encriptado = bcrypt.hashpw(password_encode, semilla)
        cur = mysql.connection.cursor()
        cur.execute("""
        UPDATE empleados 
        SET rut = %s,
            nombre = %s,
            apellido_paterno = %s,
            apellido_materno = %s,
            telefono = %s,
            direccion = %s,
            rol = %s,
            correo = %s,
            password = %s,
            id_usuario = %s
            WHERE id_empleado = %s""",
            (rut, nombre, apellido_paterno, apellido_materno, telefono, direccion, rol, correo, password_encriptado, session['id_empleado'], id))
        mysql.connection.commit()
        # flash('empresa modificada')
        return redirect(url_for('listar_usuario'))

#elimino usuario
@app.route('/delete_usuario/<string:id>')
def delete_usuario(id):
    cur = mysql.connection.cursor()
    cur.execute('UPDATE empleados SET habilitado = %s,id_usuario = %s WHERE id_Empleado = %s', (0,  session['id_empleado'], id))
    mysql.connection.commit()
    return redirect(url_for('listar_usuario'))  




####################################################### AUDITORIA ######################################################

#lista informacion tabla auditoria
@app.route('/auditoria')
def auditoria():
    cur = mysql.connection.cursor()
    cur.execute('Select * from auditoria')
    data = cur.fetchall()
    cur.execute('SELECT count(id_activo),patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_auditoria.html', auditorias = data, contadores = data5, alertas = data6)

    #lista informacion tabla auditoria_usuario
@app.route('/auditoria_usuario')
def auditoria_usuario():
    cur = mysql.connection.cursor()
    cur.execute('Select * from auditoria_usuario')
    data = cur.fetchall()
    cur.execute('SELECT count(id_activo),patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1')
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_activo LIMIT 6')
    data6 = cur.fetchall()
    return render_template('Admin_auditoria_usuario.html', usuarios = data, contadores = data5, alertas = data6)

    #descargar excel auditoria
@app.route('/download/report/excel')
def download_report():
    cur = mysql.connection.cursor()
    cur.execute('Select fecha, tabla, evento,consulta, usuario from auditoria')
    data = cur.fetchall()

    #output in bytes
    output = io.BytesIO()
    #crea hoja de trabajo
    workbook = xlwt.Workbook()
    #add a sheet
    sh = workbook.add_sheet('auditoria_report')

    #add headers
    sh.write(0, 0, 'fecha')
    sh.write(0, 1, 'tabla')
    sh.write(0, 2, 'evento')
    sh.write(0, 3, 'consulta')
    sh.write(0, 4, 'usuario')
    

    #add values
    idx = 0
    for row in data:
        sh.write(idx+1, 0, str(row[0]))
        sh.write(idx+1, 1, row[1])
        sh.write(idx+1, 2, row[2])
        sh.write(idx+1, 3, row[3])
        sh.write(idx+1, 4, row[4])
        idx += 1
    
    workbook.save(output)
    output.seek(0)

    return Response(output, mimetype="application/ms-excel", headers={"Content-Disposition":"attachment;filename=auditoria_report.xls"})


#descargar excel auditoria_usuario
@app.route('/download_usuario/report/excel')
def download_report_usuario():
    cur = mysql.connection.cursor()
    cur.execute('Select nombre, tipo, fecha_hora from auditoria_usuario')
    data = cur.fetchall()

    #output in bytes
    output = io.BytesIO()
    #crea hoja de trabajo
    workbook = xlwt.Workbook()
    #add a sheet
    sh = workbook.add_sheet('auditoria_usuario_report')

    #add headers
    sh.write(0, 0, 'nombre')
    sh.write(0, 1, 'tipo')
    sh.write(0, 2, 'fecha_hora')
   

    #add values
    idx = 0
    for row in data:
        sh.write(idx+1, 0, row[0])
        sh.write(idx+1, 1, row[1])
        sh.write(idx+1, 2, str(row[2]))
        idx += 1
    
    workbook.save(output)
    output.seek(0)

    return Response(output, mimetype="application/ms-excel", headers={"Content-Disposition":"attachment;filename=auditoria_usuario_report.xls"})

######################################################### CIERRA ADMIN #################################################################
######################################################### INICIA MINERA ################################################################
#INDEX minera 
@app.route('/minera')
def IndexMinera():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute("Select count(id_empleado) from empleados where habilitado = 1 AND id_empresa = %s", [session['id_empresa']])
    data2 = cur.fetchall()
    cur.execute("Select count(id_prestador) from prestador where habilitado = 1 AND id_empresa = %s", [session['id_empresa']])
    data3 = cur.fetchall()
    cur.execute('Select count(id_activo) from activos where habilitado = 1 AND id_empresa = %s', [session['id_empresa']])
    data4 = cur.fetchall()
    # cur.execute('SELECT count(id_activo),patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_empresa = %s', [session['id_empresa']])
    # data5 = cur.fetchall()
    # cur.execute('SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_empresa = %s AND id_activo LIMIT 6', [session['id_empresa']])
    # data6 = cur.fetchall()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6', [session['id_empresa']])
    data6 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_empresa']])
    data5 = cur.fetchall()

    return render_template('Empresa_index.html', usuarios = data2, prestadores = data3, activos = data4, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html')

########################################################## PRESTADOR POR EMPRESA ###################################################3

# Lista los prestadores creados por empresa
@app.route('/listar_prestador_empresa')
def listar_prestador_empresa():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute('Select * from prestador where habilitado = 1 AND id_empresa = %s', [session['id_empresa']])
    data = cur.fetchall()
    cur.execute('Select * from empresa where habilitado = 1 AND id_empresa = %s', [session['id_empresa']])
    dataEmpresa = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6', [session['id_empresa']])
    data6 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_empresa']])
    data5 = cur.fetchall()
    return render_template('Empresa_agregar_prestador.html', prestador = data, empresas = dataEmpresa, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html') 


#Crea prestadores por empresa
@app.route('/add_prestador_empresa' ,methods=['POST'])
def add_prestador_empresa():
    if request.method == 'POST':
        rut = request.form['rut']
        nombre = request.form['nombre']
        telefono = request.form['telefono']
        correo = request.form['correo']
        direccion = request.form['direccion']
        empresa = request.form['empresa']
        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO prestador (rut,nombre,telefono,correo,direccion,habilitado, id_usuario, id_empresa) VALUES (%s, %s, %s, %s,%s,%s,%s,%s)',
         (rut,nombre,telefono,correo,direccion,1, session['id_empleado'],empresa))
        mysql.connection.commit()
        flash('prestador agregada')
        return redirect(url_for('listar_prestador_empresa'))

#Selecciona al prestador a modificar por empresa
@app.route('/edit_prestador_empresa/<id>')
def get_prestador_empresa(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM prestador WHERE id_prestador = {0}'.format(id))
    data = cur.fetchall()
    cur.execute('Select * from empresa where habilitado = 1')
    dataEmpresa = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6', [session['id_empresa']])
    data6 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_empresa']])
    data5 = cur.fetchall()
    return render_template('Empresa_edit_prestador.html', prestadores = data[0], empresas = dataEmpresa, contadores = data5, alertas = data6)

# Modifica prestador
@app.route('/update_prestador_empresa/<id>', methods = ['POST'])
def update_prestador_empresa(id):
    if request.method == 'POST':
        rut = request.form['rut']
        nombre = request.form['nombre']
        telefono = request.form['telefono']
        correo = request.form['correo']
        direccion = request.form['direccion']
        cur = mysql.connection.cursor()
        cur.execute("""
        UPDATE prestador 
        SET rut = %s,
        nombre = %s,
        telefono = %s,
        correo = %s,
        direccion = %s,
        id_usuario = %s
        WHERE id_prestador = %s"""
        , (rut, nombre, telefono, correo, direccion, session['id_empleado'], id))
        mysql.connection.commit()
        # flash('Prestador modificado')
        return redirect(url_for('listar_prestador_empresa'))

#elimina prestador
@app.route('/delete_prestador_empresa/<string:id>')
def delete_prestador_empresa(id):
    cur = mysql.connection.cursor()
    #cur.execute('UPDATE prestador SET habilitado = 0 WHERE id_prestador = {0}'.format(id))
    cur.execute('UPDATE prestador SET habilitado = %s,id_usuario = %s WHERE id_prestador = %s', (0,  session['id_empleado'], id))
    mysql.connection.commit()
    flash('prestador eliminado')
    return redirect(url_for('listar_prestador_empresa'))    

########################################################################################################################################
######################################################### ACTIVOS por empresa ############################################################

# Lista los activos
@app.route('/listar_activo_empresa')
def listar_activo_empresa():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    ##cur.execute('Select * from activos where habilitado = 1 AND id_empresa = %s', [session['id_empresa']])
    cur.execute('Select a.id_activo, a.patente, a.tipo_vehiculo, a.marca, a.modelo, a.fecha_rev_tec, a.fecha_perm_circ, p.nombre from activos a INNER JOIN empresa e on e.id_empresa = a.id_empresa INNER JOIN prestador p on p.id_prestador = a.id_prestador where a.habilitado = 1 AND a.id_empresa = %s', [session['id_empresa']])
    data = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('Select * from empresa where habilitado = 1 AND id_empresa = %s', [session['id_empresa']])
    dataEmpresa = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('Select * from prestador where habilitado = 1 AND id_empresa = %s', [session['id_empresa']])
    dataPrestador = cur.fetchall()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6', [session['id_empresa']])
    data6 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_empresa']])
    data5 = cur.fetchall()
    return render_template('Empresa_agregar_activo.html', activos = data, empresas= dataEmpresa, prestadores = dataPrestador, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html')    

#@app.route('/proveedor')
#def IndexProveedor():
#    cur = mysql.connection.cursor()
#    cur.execute('Select * from activos where habilitado = 1')
#    data = cur.fetchall()
#    return render_template('indexPrestador.html', activos = data)


# Crea activos
@app.route('/add_activo_empresa' , methods=['POST'])
def add_activo_empresa():
    if request.method == 'POST':

        patente = request.form['patente']
        tipo_vehiculo = request.form['tipo_vehiculo']
        marca = request.form['marca']
        modelo = request.form['modelo']
        numero_motor = request.form['numero_motor']
        chasis = request.form['chasis']
        color = request.form['color']
        anio = request.form['año']
        fecha_rev_tec = request.form['fecha_rev_tec']
        fecha_perm_circ = request.form['fecha_perm_circ']
        combustible = request.form['combustible']
        transmision = request.form['transmision']
        empresa = request.form['empresa'] if request.form['empresa'] != '0' else None
        proveedor = request.form['proveedor'] if request.form['proveedor'] != '0' else None
        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador, id_usuario) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, 1, empresa, proveedor, session['id_empleado']))
        mysql.connection.commit()
        flash('activos agregada')
        return redirect(url_for('listar_activo_empresa'))

#selecciono activo a editar
@app.route('/edit_activo_empresa/<id>')
def get_activo_empresa(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM activos WHERE id_activo = %s', [id])
    data = cur.fetchall()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6', [session['id_empresa']])
    data6 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_empresa']])
    data5 = cur.fetchall()
    return render_template('Empresa_edit_activo.html', activos = data[0], contadores = data5, alertas = data6)

#Edito activo
@app.route('/update_activo_empresa/<id>', methods = ['POST'])
def update_activo_empresa(id):
    if request.method == 'POST':
        patente = request.form['patente']
        tipo_vehiculo = request.form['tipo_vehiculo']
        marca = request.form['marca']
        modelo = request.form['modelo']
        numero_motor = request.form['numero_motor']
        chasis = request.form['chasis']
        color = request.form['color']
        anio = request.form['año']
        fecha_rev_tec = request.form['fecha_rev_tec']
        fecha_perm_circ = request.form['fecha_perm_circ']
        combustible = request.form['combustible']
        transmision = request.form['transmision']
        cur = mysql.connection.cursor()
        # cur.execute(""" UPDATE activos SET patente = %s, tipo_vehiculo = %s, WHERE id_activo = %s""", (patente, tipo_vehiculo, id))
        cur.execute("""
            UPDATE activos 
            SET patente = %s,
                tipo_vehiculo = %s,
                marca = %s,
                modelo = %s,
                numero_motor = %s,
                chasis = %s,
                color = %s,
                anio = %s,
                fecha_rev_tec = %s,
                fecha_perm_circ = %s,
                combustible = %s,
                transmision = %s,
                id_usuario = %s
            WHERE id_activo = %s  
        """, (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, session['id_empleado'], id))
        mysql.connection.commit()
        # flash('Prestador modificado')
        return redirect(url_for('listar_activo_empresa'))

#Elimino Activo
@app.route('/delete_activo_empresa/<string:id>')
def delete_activo_empresa(id):
    cur = mysql.connection.cursor()
    #cur.execute('UPDATE activos SET habilitado = 0 WHERE id_activo = {0}'.format(id))
    cur.execute('UPDATE activos SET habilitado = %s,id_usuario = %s WHERE id_activo = %s', (0,  session['id_empleado'], id))
    mysql.connection.commit()
    flash('prestador eliminado')
    return redirect(url_for('listar_activo_empresa'))


###################################################################################################################################
####################################################### USUARIOS por empresa ###########################################################

#Lista los usuarios creados
@app.route('/listar_usuario_empresa')
def listar_usuario_empresa():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute('Select * from empleados where habilitado = 1 AND id_empresa = %s', [session['id_empresa']])
    data = cur.fetchall()
    cur = mysql.connection.cursor()
    cur.execute('Select * from prestador where habilitado = 1 AND id_empresa = %s', [session['id_empresa']])
    datos = cur.fetchall()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6', [session['id_empresa']])
    data6 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_empresa']])
    data5 = cur.fetchall()
    return render_template('Empresa_agregar_usuario.html', empresas = datos, empleados = data, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html')




##############################################################################################################################

# #Lista las empresas para ser asignadas a un usuario
# @app.route('/FormRegistro_empresa')
# def FormRegistro():
#   cur = mysql.connection.cursor()
#   cur.execute('Select * from empresa where habilitado = 1')
#   data = cur.fetchall()
#   return render_template('agregar_usuario.html', empresas = data)


# RUTA PARA REGISTRAR USUARIOS
@app.route('/registro_empresa', methods = ["GET", "POST"])
def Registro_empresa():

  if (request.method=='POST'):
    
     # VERIFICA QUE HAYA UNA SESION ACTIVA
    #  if 'nombre' in session:
    #    # carga vista de index
    #           cur = mysql.connection.cursor()
    #           cur.execute('Select * from empresa where habilitado = 1')
    #           data = cur.fetchall()
    #           return render_template('index.html', empresas = data)
    #  else:
    #    # carga vista de login 
    #    return render_template('login.html')

   #else:
  # OBTENGO LOS DATOS DEL FORMULARIO REGISTRO
    rut = request.form['rut']
    nombre = request.form['nombre']
    apellido_paterno = request.form['apellido_paterno']
    apellido_materno = request.form['apellido_materno']
    telefono = request.form['telefono']
    direccion = request.form['direccion']
    rol = request.form['rol']  
    correo = request.form['correo']
    password = request.form['password']
    id_permiso = int(rol)
    password_encode = password.encode("utf-8")
    id_empresa = session['id_empresa']
    id_prestador = request.form['empresa']
    password_encriptado = bcrypt.hashpw(password_encode, semilla)
    #QUERY PARA INSERCION DE LOS DATOS EN LA TABLA
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO empleados (rut, nombre, apellido_paterno, apellido_materno, telefono, direccion, rol, correo, password, id_permiso, id_empresa, habilitado, id_usuario, id_prestador) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', ((rut, nombre, apellido_paterno, apellido_materno, telefono, direccion, rol, correo, password_encriptado, id_permiso, id_empresa, 1, session['id_empleado'], id_prestador)))
    mysql.connection.commit()
    # # Registro la sesion
    # session['nombre'] = nombre
    # # session['email'] = email
    # RETORNO AL LOGIN PARA QUE INGRESE EL USUARIO REGISTRADO
    return redirect(url_for('listar_usuario_empresa'))

#Selecciono el usuario a editar
@app.route('/edit_usuario_empresa/<id>')
def get_edit_usuario_empresa(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM empleados WHERE id_empleado = {0}'.format(id))
    data = cur.fetchall()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6', [session['id_empresa']])
    data6 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_empresa']])
    data5 = cur.fetchall()
    return render_template('Empresa_edit_usuario.html', empleados = data[0], contadores = data5, alertas = data6)

# Actualizar Usuario
@app.route('/update_empleado_empresa/<id>',  methods = ['POST'])
def update_usuario_empresa(id):
    if (request.method == 'POST'):
        rut = request.form['rut']
        nombre = request.form['nombre']
        apellido_paterno = request.form['apellido_paterno']
        apellido_materno = request.form['apellido_materno']
        telefono = request.form['telefono']
        direccion = request.form['direccion']
        rol = request.form['rol']
        correo = request.form['correo']
        password = request.form['password']
        password_encode = password.encode("utf-8")
        password_encriptado = bcrypt.hashpw(password_encode, semilla)
        cur = mysql.connection.cursor()
        cur.execute("""
        UPDATE empleados 
        SET rut = %s,
            nombre = %s,
            apellido_paterno = %s,
            apellido_materno = %s,
            telefono = %s,
            direccion = %s,
            rol = %s,
            correo = %s,
            password = %s,
            id_usuario = %s
            WHERE id_empleado = %s""",
            (rut, nombre, apellido_paterno, apellido_materno, telefono, direccion, rol, correo, password_encriptado, session['id_empleado'], id))
        mysql.connection.commit()
        # flash('empresa modificada')
        return redirect(url_for('listar_usuario_empresa'))

#elimino usuario
@app.route('/delete_usuario_empresa/<string:id>')
def delete_usuario_empresa(id):
    cur = mysql.connection.cursor()
    cur.execute('UPDATE empleados SET habilitado = %s,id_usuario = %s WHERE id_Empleado = %s', (0,  session['id_empleado'], id))
    mysql.connection.commit()
    return redirect(url_for('listar_usuario_empresa'))  

######################################################### CIERRA EMPRESA ###############################################################
######################################################### INICIA PRESTADOR ################################################################
#INDEX prestador 
@app.route('/prestador')
def IndexPrestador():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute('Select count(id_empleado) from empleados where habilitado = 1 AND id_prestador = %s', [session['id_prestador']])
    # Query = "SELECT nombre, correo, password, permiso.id_permiso, id_empleado FROM empleados INNER JOIN permiso ON empleados.id_permiso = permiso.id_permiso  WHERE correo = %s"
    data2 = cur.fetchall()
    cur.execute('Select count(id_activo) from activos where habilitado = 1 AND id_prestador = %s', [session['id_prestador']])
    data4 = cur.fetchall()
    cur.execute('SELECT count(id_activo),patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s', [session['id_prestador']])
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s AND id_activo LIMIT 6', [session['id_prestador']])
    data6 = cur.fetchall()
    return render_template('Prestador_index.html', usuarios = data2, activos = data4, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html')

######################################################### ACTIVOS por prestador ############################################################

# Lista los activos
@app.route('/listar_activo_prestador')
def listar_activo_prestador():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute('Select * from activos where habilitado = 1 AND id_prestador = %s', [session['id_prestador']])
    data = cur.fetchall()
    cur.execute('SELECT count(id_activo),patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s', [session['id_prestador']])
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s AND id_activo LIMIT 6', [session['id_prestador']])
    data6 = cur.fetchall()
    return render_template('Prestador_agregar_activo.html', activos = data, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html')    

#@app.route('/proveedor')
#def IndexProveedor():
#    cur = mysql.connection.cursor()
#    cur.execute('Select * from activos where habilitado = 1')
#    data = cur.fetchall()
#    return render_template('indexPrestador.html', activos = data)


# Crea activos
@app.route('/add_activo_prestador' , methods=['POST'])
def add_activo_prestador():
    if request.method == 'POST':

        patente = request.form['patente']
        tipo_vehiculo = request.form['tipo_vehiculo']
        marca = request.form['marca']
        modelo = request.form['modelo']
        numero_motor = request.form['numero_motor']
        chasis = request.form['chasis']
        color = request.form['color']
        anio = request.form['año']
        fecha_rev_tec = request.form['fecha_rev_tec']
        fecha_perm_circ = request.form['fecha_perm_circ']
        combustible = request.form['combustible']
        transmision = request.form['transmision']
        empresa = None
        proveedor = session['id_prestador']
        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador, id_usuario) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, 1, empresa, proveedor, session['id_empleado']))
        mysql.connection.commit()
        flash('activos agregada')
        return redirect(url_for('listar_activo_prestador'))

#selecciono activo a editar
@app.route('/edit_activo_prestador/<id>')
def get_activo_prestador(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM activos WHERE id_activo = %s', [id])
    data = cur.fetchall()
    cur.execute('SELECT count(id_activo),patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s', [session['id_prestador']])
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s AND id_activo LIMIT 6', [session['id_prestador']])
    data6 = cur.fetchall()
    return render_template('Prestador_edit_activo.html', activos = data[0], contadores = data5, alertas = data6)

#Edito activo
@app.route('/update_activo_prestador/<id>', methods = ['POST'])
def update_activo_prestador(id):
    if request.method == 'POST':
        patente = request.form['patente']
        tipo_vehiculo = request.form['tipo_vehiculo']
        marca = request.form['marca']
        modelo = request.form['modelo']
        numero_motor = request.form['numero_motor']
        chasis = request.form['chasis']
        color = request.form['color']
        anio = request.form['año']
        fecha_rev_tec = request.form['fecha_rev_tec']
        fecha_perm_circ = request.form['fecha_perm_circ']
        combustible = request.form['combustible']
        transmision = request.form['transmision']
        cur = mysql.connection.cursor()
        # cur.execute(""" UPDATE activos SET patente = %s, tipo_vehiculo = %s, WHERE id_activo = %s""", (patente, tipo_vehiculo, id))
        cur.execute("""
            UPDATE activos 
            SET patente = %s,
                tipo_vehiculo = %s,
                marca = %s,
                modelo = %s,
                numero_motor = %s,
                chasis = %s,
                color = %s,
                anio = %s,
                fecha_rev_tec = %s,
                fecha_perm_circ = %s,
                combustible = %s,
                transmision = %s,
                id_usuario = %s
            WHERE id_activo = %s  
        """, (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, session['id_empleado'], id))
        mysql.connection.commit()
        # flash('Prestador modificado')
        return redirect(url_for('listar_activo_prestador'))

#Elimino Activo
@app.route('/delete_activo_prestador/<string:id>')
def delete_activo_prestador(id):
    cur = mysql.connection.cursor()
    #cur.execute('UPDATE activos SET habilitado = 0 WHERE id_activo = {0}'.format(id))
    cur.execute('UPDATE activos SET habilitado = %s,id_usuario = %s WHERE id_activo = %s', (0,  session['id_empleado'], id))
    mysql.connection.commit()
    flash('prestador eliminado')
    return redirect(url_for('listar_activo_prestador'))


###################################################################################################################################
####################################################### USUARIOS por prestador ###########################################################

#Lista los usuarios creados
@app.route('/listar_usuario_prestador')
def listar_usuario_prestador():
  if 'nombre' in session:
  #### CONSULTA PARA TRAER LOS DATOS DE LAS EMPRESAS ASOCIADAS ####
    cur = mysql.connection.cursor()
    cur.execute('Select * from empleados where habilitado = 1 AND id_prestador = %s', [session['id_prestador']])
    data = cur.fetchall() 
    cur.execute('SELECT count(id_activo),patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s', [session['id_prestador']])
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s AND id_activo LIMIT 6', [session['id_prestador']])
    data6 = cur.fetchall()  
    return render_template('Prestador_agregar_usuario.html', empleados = data, contadores = data5, alertas = data6)
  else:                 
    return render_template('login.html')




##############################################################################################################################



# RUTA PARA REGISTRAR USUARIOS
@app.route('/registro_prestador', methods = ["GET", "POST"])
def Registro_prestador():

  if (request.method=='POST'):
    
     # VERIFICA QUE HAYA UNA SESION ACTIVA
    #  if 'nombre' in session:
    #    # carga vista de index
    #           cur = mysql.connection.cursor()
    #           cur.execute('Select * from empresa where habilitado = 1')
    #           data = cur.fetchall()
    #           return render_template('index.html', empresas = data)
    #  else:
    #    # carga vista de login 
    #    return render_template('login.html')

   #else:
  # OBTENGO LOS DATOS DEL FORMULARIO REGISTRO
    rut = request.form['rut']
    nombre = request.form['nombre']
    apellido_paterno = request.form['apellido_paterno']
    apellido_materno = request.form['apellido_materno']
    telefono = request.form['telefono']
    direccion = request.form['direccion']
    rol = request.form['rol']  
    correo = request.form['correo']
    password = request.form['password']
    id_permiso = int(rol)
    password_encode = password.encode("utf-8")
    empresa = None
    id_prestador = session['id_prestador']
    password_encriptado = bcrypt.hashpw(password_encode, semilla)
    #QUERY PARA INSERCION DE LOS DATOS EN LA TABLA
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO empleados (rut, nombre, apellido_paterno, apellido_materno, telefono, direccion, rol, correo, password, id_permiso, id_empresa, habilitado, id_usuario, id_prestador) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', ((rut, nombre, apellido_paterno, apellido_materno, telefono, direccion, rol, correo, password_encriptado, id_permiso, empresa, 1, session['id_empleado'], id_prestador)))
    mysql.connection.commit()
    # # Registro la sesion
    # session['nombre'] = nombre
    # # session['email'] = email
    # RETORNO AL LOGIN PARA QUE INGRESE EL USUARIO REGISTRADO
    return redirect(url_for('listar_usuario_prestador'))

#Selecciono el usuario a editar
@app.route('/edit_usuario_prestador/<id>')
def get_edit_usuario_prestador(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM empleados WHERE id_empleado = {0}'.format(id))
    data = cur.fetchall()
    cur.execute('SELECT count(id_activo),patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s', [session['id_prestador']])
    data5 = cur.fetchall()
    cur.execute('SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1 AND id_prestador = %s AND id_activo LIMIT 6', [session['id_prestador']])
    data6 = cur.fetchall()
    return render_template('Prestador_edit_usuario.html', empleados = data[0], contadores = data5, alertas = data6)

# Actualizar Usuario
@app.route('/update_empleado_prestador/<id>',  methods = ['POST'])
def update_usuario_prestador(id):
    if (request.method == 'POST'):
        rut = request.form['rut']
        nombre = request.form['nombre']
        apellido_paterno = request.form['apellido_paterno']
        apellido_materno = request.form['apellido_materno']
        telefono = request.form['telefono']
        direccion = request.form['direccion']
        rol = request.form['rol']
        correo = request.form['correo']
        password = request.form['password']
        password_encode = password.encode("utf-8")
        password_encriptado = bcrypt.hashpw(password_encode, semilla)
        cur = mysql.connection.cursor()
        cur.execute("""
        UPDATE empleados 
        SET rut = %s,
            nombre = %s,
            apellido_paterno = %s,
            apellido_materno = %s,
            telefono = %s,
            direccion = %s,
            rol = %s,
            correo = %s,
            password = %s,
            id_usuario = %s
            WHERE id_empleado = %s""",
            (rut, nombre, apellido_paterno, apellido_materno, telefono, direccion, rol, correo, password_encriptado, session['id_empleado'], id))
        mysql.connection.commit()
        # flash('empresa modificada')
        return redirect(url_for('listar_usuario_prestador'))

#elimino usuario
@app.route('/delete_usuario_prestador/<string:id>')
def delete_usuario_prestador(id):
    cur = mysql.connection.cursor()
    cur.execute('UPDATE empleados SET habilitado = %s,id_usuario = %s WHERE id_Empleado = %s', (0,  session['id_empleado'], id))
    mysql.connection.commit()
    return redirect(url_for('listar_usuario_prestador'))

##############################################################  GUARDIA   ########################################3
#INDEX guardia
@app.route('/Guardia')
def IndexGuardia():
  if 'nombre' in session:
    return render_template('Usuario_index.html')
  else:                 
    return render_template('login.html')

#Validacion de patente por parte del guardia
@app.route('/validarPatente', methods=['POST'])
def validarPatente():
    if request.method == 'POST':
        #asignar imagen a una variable
        placa = request.files.getlist('placa')
        print('###################################################################')
        print(placa)
        #for para recorrer las imagenes agregadas
        for file in placa:
                #obtener el nombre de la imagen
                filename = secure_filename(file.filename)
                #guardar la imagen en la carpeta raiz
                file.save(os.getcwd() + "/" + filename)
                #metodo para leer la imagen
                placa2 = []
                imageIn = cv2.imread(filename)
                image = imutils.resize(imageIn, width=600)
                gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
                gray = cv2.blur(gray, (3,3))
                canny = cv2.Canny(gray,150,300)
                canny = cv2.dilate(canny,None,iterations=0)

                cnts,_ = cv2.findContours(canny,cv2.RETR_LIST,cv2.CHAIN_APPROX_SIMPLE)
                #cv2.drawContours(image,cnts,-1,(0,255,0),2)

                for c in cnts:
                    area = cv2.contourArea(c)
                    x,y,w,h = cv2.boundingRect(c)
                    epsilon = 0.09*cv2.arcLength(c,True)
                    approx = cv2.approxPolyDP(c,epsilon,True)
                    #if de configuración de parametros
                    if  area > 1000 and area < 9000:
                        print('area=', area)
                        #cv2.drawContours(image,[c],0,(0,255,0),2)
                        aspect_ratio = float(w)/h
                        if aspect_ratio>2.4:
                        #cv2.drawContours(image,[c],0,(0,255,0),2)
                            placa2 = gray[y:y+h,x:x+w]
                            #obtener texto de la imagen
                            text = pytesseract.image_to_string(placa2, config='--psm 11')                    
                            #recortar el texto para obtener los valores necesarios de la patente
                            text2 = re.sub("\-|\°|\♀|\'|\‘|\.|\*|\ |\:|\)","",text)
                            text3 = text2[0:6]
                            cv2.imshow('placa2',placa2)
                            cv2.moveWindow('placa2',780,10)
                            cv2.rectangle(image,(x,y),(x+w,y+h),(0,255,0),3)
                            cv2.putText(image,text3,(x-20,y-10),1,2.2,(0,255,0),3)
                            #eliminar la imagen de la carpeta raiz
                            remove(filename)
                            placa = text3
                            cur = mysql.connection.cursor()
                            # Query = "SELECT patente, fecha_rev_tec, fecha_perm_circ FROM activos WHERE patente = %s"
                            Query = 'SELECT patente, fecha_rev_tec, fecha_perm_circ, CASE WHEN fecha_rev_tec > CURDATE() THEN 1 ELSE 0 END as permitido_rt, CASE WHEN fecha_perm_circ > CURDATE() THEN 1 ELSE 0 END as permitido_pc FROM activos WHERE patente = %s'
                            cur.execute(Query, [placa])
                            data = cur.fetchall() 


                            return render_template('Usuario_index.html', patentes = data)

########################################################## escaneo OCR empresa ################################################
#@app.route('/cargaImagen')
#def cargaImagen():
#  return render_template('lectura_documentos.html')
   

##Escaneo OCR por parte de la empresa
#@app.route('/escaneo', methods=['POST'])
#def Escaneo():
#    if request.method == 'POST':


#      #asignar imagen a una variable
#      documento = request.files.getlist('documento')
#      #for para recorrer las imagenes agregadas
#      for file in documento:

#        #obtener el nombre de la imagen
#        filename = secure_filename(file.filename)
#        #guardar la imagen en la carpeta raiz
#        file.save(os.getcwd() + "/" + filename)
#        image = cv2.imread(filename)
#        text = pytesseract.image_to_string(image, lang='spa')
#        print('Texto: ', text)
#        data = text
#        remove(filename)
#        return render_template('lectura_documentos.html', escaneo = data)


@app.route('/cargaImagen')
def AgregarPantete():
    return render_template('lectura_documentos_copia.html')

#metodo para leer imagen
@app.route('/validarPatente_2', methods=['POST'])
def validarPatente_2():
    if request.method == 'POST':
        #asignar imagen a una variable
        texto = request.files.getlist('documento')
        print('##########################################################################1')
        print(texto)
        #for para recorrer las imagenes agregadas
        for file in texto:
          filename = secure_filename(file.filename)
          print('#########################################2')
          print(filename)
          file.save(os.getcwd() + "/" + filename)
          image = cv2.imread(filename)
          text = pytesseract.image_to_string(image,lang='spa')
          print('Texto: ',text)
          data = text
          remove(filename)
          return render_template('lectura_documentos_copia.html', texto = data)

@app.route('/alerta')
def Alertas():
  if 'nombre' in session:
    cur = mysql.connection.cursor()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6')
    #cur.execute('SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1')
    data = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'')
    #cur.execute('SELECT count(id_activo),patente,DATE_FORMAT(fecha_rev_tec, "%d/%m/%Y"), CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END,DATE_FORMAT(fecha_perm_circ, "%d/%m/%Y"), CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END FROM activos WHERE habilitado = 1')
    data2 = cur.fetchall()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'')
    data3 = cur.fetchall()
    return render_template('alertaAdmin.html', alertas = data, contadores = data2, mensajes = data3)         

@app.route('/alerta_empresa')
def Alertas_Empresa():
  if 'nombre' in session:
    cur = mysql.connection.cursor()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6', [session['id_empresa']])
    data6 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_empresa']])
    data5 = cur.fetchall()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_empresa = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_empresa']])
    data3 = cur.fetchall()
    return render_template('alertaEmpresa.html', alertas = data6, contadores = data5, mensajes = data3) 
   
@app.route('/alerta_prestador')
def Alertas_Prestador():
  if 'nombre' in session:
    cur = mysql.connection.cursor()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_prestador = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"' LIMIT 6', [session['id_prestador']])
    data6 = cur.fetchall()
    cur.execute('SELECT COUNT(VIGENTE.id_activo) from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_prestador = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_prestador']])
    data5 = cur.fetchall()
    cur.execute('SELECT * from (SELECT id_activo,patente,fecha_rev_tec, CASE WHEN fecha_rev_tec < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_rev_tec >= CURRENT_DATE AND fecha_rev_tec <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioA'"',fecha_perm_circ, CASE WHEN fecha_perm_circ < CURRENT_DATE THEN '"'VENCIDO'"' ELSE CASE WHEN fecha_perm_circ >= CURRENT_DATE AND fecha_perm_circ <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) THEN '"'ALERTA'"' ELSE '"'VIGENTE'"' END END AS '"'cambioB'"' FROM activos WHERE habilitado = 1 AND id_prestador = %s) AS VIGENTE WHERE VIGENTE.cambioA <> '"'VIGENTE'"' OR VIGENTE.cambioB <> '"'VIGENTE'"'', [session['id_prestador']])
    data3 = cur.fetchall()
    return render_template('alertaPrestador.html', alertas = data6, contadores = data5, mensajes = data3)   


####################################################FORGOT##########################################################

@app.route('/forgot', methods=["POST", "GET"])
def forgot():
  if 'nombre' in session:
    return redirect('/')
  if request.method == 'POST':
    correo = request.form['correo']
    print(correo)
    token = str(uuid.uuid4())
    cur = mysql.connection.cursor()
    resultado = cur.execute("SELECT * FROM empleados WHERE habilitado = 1 AND correo = %s", [correo])
    print(resultado)

    if resultado > 0:
      cur = mysql.connection.cursor()
      cur.execute("UPDATE empleados SET token = %s WHERE correo = %s",[token, correo])
      mysql.connection.commit()
      cur = mysql.connection.cursor()
      cur.execute("SELECT * FROM empleados WHERE habilitado = 1 AND correo = %s",[correo])
      resultado2 = cur.fetchall()
      flash('correo enviado')
      msg = Message('Recuperación de contraseña',
                    sender= "checkdrive9@gmail.com", 
                    recipients=[correo])
      msg.html = render_template('email.html', datos = resultado2)
      mail.send(msg)
      return redirect(url_for('codigo_validacion'))
    else:
        flash("correo equivocado", "alert-danger")

  return render_template('forgot2.html')

@app.route('/codigo_validacion', methods=["POST", "GET"])
def codigo_validacion():
  if 'nombre' in session:
    return redirect('/')

  if request.method == 'POST':
    codigo = request.form['codigo']
    cur = mysql.connection.cursor()
    cur.execute("SELECT id_empleado, id_permiso FROM empleados WHERE habilitado = 1 AND token = %s",[codigo])
    resultados = cur.fetchone()
    session['id_permiso'] = resultados[1]
    print(resultados[0])
    if resultados != 0:
      flash('Código correcto')  
      return render_template('reset.html', data = resultados)
    else:
      flash('Código incorrecto')  
  return render_template('codigo_validacion.html')


#password = request.form['password']

@app.route('/reset/<id>', methods = ["POST"])
def reset(id):
    if request.method == 'POST':
      password = request.form['password']
      password2 = request.form['password2']
      if password == password2:
        password_encode = password.encode("utf-8")
        password_encriptado = bcrypt.hashpw(password_encode, semilla)
        cur = mysql.connection.cursor()
        cur.execute("""
        UPDATE empleados 
        SET password = %s
          WHERE id_empleado = %s""",
          (password_encriptado, id))
        mysql.connection.commit()
        return render_template('login.html')
      else:
        flash('contraseña incorrecta')
        # return render_template('reset.html') 
        return redirect(url_for('reset')) 




if __name__ == '__main__':
  app.run(port = 80, debug = True)

