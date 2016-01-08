# -*- coding: utf-8 -*-
from flask import (
    Flask,
    request,
    render_template,
    redirect,
    jsonify,
    Response,
    url_for)
import MySQLdb
import json
import hashlib
from functools import wraps

DB_HOST = 'localhost'
DB_USER = 'root'
DB_PASS = ''


def conectar():
    """Crea la conexión a la base de datos"""
    conn = MySQLdb.connect(DB_HOST, DB_USER, DB_PASS)
    cursor = conn.cursor()
    cursor.execute('use proyecto_web;')
    return conn

app = Flask(__name__)

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if valid_login(
                request.form['user'],
                request.form['Password']):
            return redirect(url_for('principal'))
            #return render_template("principal.html")
        else:
            error = u"Usuario o contraseña no corresponden"
            return render_template("login.html", error=error)
    else:
        return render_template("login.html", error=error)

def valid_login(username, password):
    # esto debería ser dinamico, Un salt para cada usuario (o grupos de usuario)
    salt="6ghn"
    conn = conectar()
    hash_pass = hashlib.sha224("{}{}".format(password, salt)).hexdigest()
    cursor = conn.cursor()
    sql = 'SELECT idUsuario FROM usuario WHERE nombre = %s AND password = %s'
    cursor.execute(sql, (username, hash_pass))
    existe = cursor.fetchall()
    cursor.close()
    if len(existe) > 0:
        return True
    else:
        return False

    return False


@app.route("/")
def principal():
    return render_template('principal.html')




@app.route("/resumen", methods=['GET', 'POST'])
def resumen():
    if request.method == 'POST':
        sCalle = (request.form["calle"]).encode('utf-8')
        sCalle2 = (request.form["calle2"]).encode('utf-8')
        sSector = (request.form["sector"]).encode('utf-8')
        sPoblacion = (request.form["poblacion"]).encode('utf-8')
        sRef = (request.form["ref"]).encode('utf-8')
        sDescripcion = (request.form["descripcion"]).encode('utf-8')
        sContacto = (request.form["contacto"]).encode('utf-8')
        sCodigo = (request.form["codigo"]).encode('utf-8')
        iCodigo=nombre_codigo(sCodigo)
       
    
        bien = emergencia(sCalle, sCalle2, sSector, sPoblacion, sRef, sDescripcion, sContacto, sCodigo)
                       
        if bien:
            return render_template('resumen.html', error="201",calle1=sCalle,calle2=sCalle2,sector=sSector,poblacion=sPoblacion,ref=sRef,descripcion=sDescripcion,contacto=sContacto,codigo=iCodigo,pkCodigo=sCodigo)
            
        else:
            return render_template('principal.html', error="500")
    else:
        return render_template('principal.html')
def emergencia(sCalle, sCalle2, sSector, sPoblacion, sRef, sDescripcion, sContacto, sCodigo):
    """
    Ingresa un nuevo despacho a la base de datos.
    Retorna True si la operación se realizo con exito.
    """
    conn = conectar()
    cursor= conn.cursor()
    
    sql = 'INSERT INTO emergencia(poblacion,sector,callePrincipal, calleSecundaria, poi, descripcion, contacto,Codigo_idCodigo)'
    sql += 'VALUES (%s,%s,%s,%s,%s,%s,%s,%s)'#(sPoblacion,sSector,sCalle,sCalle2,sRef,sDescripcion,sContacto,iCodigo)'
    

    try:
        cursor.execute(sql,(sPoblacion,sSector,sCalle,sCalle2,sRef,sDescripcion,sContacto,sCodigo))
        conn.commit()
        cursor.close()
        
        return True
    except MySQLdb.Error as e:
        print "Error al añadir nuevo despacho/emergencia:", e.args[0]
        cursor.close()
        return False


def nombre_codigo(sCodigo):
    conn=conectar()
    cursor=conn.cursor()
    sql='SELECT codigo from codigo where idCodigo=%s'
    try:
        cursor.execute(sql,[sCodigo])
        result=cursor.fetchone()
        for row in result:
            sNombreCodigo= result[0]
        cursor.close()
        print(sNombreCodigo)
        return sNombreCodigo

    except MySQLdb.Error as e:
        print "Error kek", e.arg[0]
        cursor.close()
        return None

@app.route("/resumen/despacho", methods=['GET', 'POST'])
def despacho():
    if request.method == 'POST':
        sCalle = (request.form["calle1"]).encode('utf-8')
        sCalle2 = (request.form["calle2"]).encode('utf-8')
        sSector = (request.form["sector"]).encode('utf-8')
        sPoblacion = (request.form["poblacion"]).encode('utf-8')
        sRef = (request.form["poi"]).encode('utf-8')
        sDescripcion = (request.form["descripcion"]).encode('utf-8')
        sContacto = (request.form["contacto"]).encode('utf-8')
        sCodigo = (request.form["codigo"]).encode('utf-8')
        iCodigo= (request.form["pkcodigo"].encode('utf-8'))
        iCompania= (request.form["compania"].encode('utf-8'))
        sMaquinas=llegada_especialidad(iCompania,iCodigo) #esto el resultado de una query
        return render_template('resumen_completo.html', error="201",calle1=sCalle,calle2=sCalle2,sector=sSector,poblacion=sPoblacion,ref=sRef,descripcion=sDescripcion,contacto=sContacto,codigo=sCodigo,maquina=sMaquinas,compania=iCompania)
        
@app.route("/Cualquiera", methods=['GET','POST'])
def despachar():
    if request.method == 'POST':
        iemer= conn.insert_id()
        icom = (request.form["compania"]).encode('utf-8')
        icod = (request.form["pkcodigo"]).encode('utf-8')
        carro = (request.form["ananohizonada"]).encode('utf-8')
         
               

#Obtenemos la compañia que llega más rapido y la especialidad!
#Si por algun motivo coinciden, solo se mostrara una vez la maquina a despachar
def llegada_especialidad(iCompania, iCodigo):
    conn=conectar()
    cursor=conn.cursor()
    sql='SELECT c.nombre from carro c, compania p where c.Compania_idCompania=idCompania and idCompania=%s '
    sql+='union ' 
    sql+='SELECT nombre  from carro, (SELECT Carro_idCarro From especialidad where Codigo_idCodigo=%s) a where idCarro=a.carro_idcarro'
    cursor.execute(sql,[iCompania,iCodigo])
    llegada=cursor.fetchall()
    cursor.close()
    return llegada






if __name__ == "__main__":
    app.run(debug=True)
