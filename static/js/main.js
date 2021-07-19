function validaUsuario(){
    
    
    //Validacion Rut: 7 a 8 números seguido de guion y digito verificador numero o k
    var rut = document.getElementById('rut');
    var expRut = /^\d{7,8}\-[0-9kK]$/;
    if (!rut.value.match(expRut) || rut.value == "") {
        alert("Rut obligatorio, debe tener entre 7 y 8 números seguidos con el digito verificador.   Ej: 12345678-1");
        rut.focus();
        return false;
    }

    
    var rutEsValido = VerificaRut(rut.value);
    if(rutEsValido == 'no'){
        alert("Rut no válido, ingrese un rut válido.");
        rut.focus();
        return false;
    }
    

    //Validacion Nombre
    var nombre = document.getElementById('nombre');
    var expNombre = /^[a-zA-Z\s]{0,50}$/;
    if (!nombre.value.match(expNombre) || nombre.value == "") {
        alert("Nombre es obligatorio, debe ingresar solo letras.");
        nombre.focus();
        return false;
    }

    //Validacion apellido
    var apellido_paterno = document.getElementById('apellido_paterno');
    var expApellido_paterno = /^[a-zA-Z\s]{0,50}$/;
    if (!apellido_paterno.value.match(expApellido_paterno) || apellido_paterno.value == "") {
        alert("Apellido paterno es obligatorio, debe ingresar solo letras.");
        apellido_paterno.focus();
        return false;
    }

    //Validacion apellido
    var apellido_materno = document.getElementById('apellido_materno');
    var expApellido_materno = /^[a-zA-Z\s]{0,50}$/;
    if (!apellido_materno.value.match(expApellido_materno) || apellido_materno.value == "") {
        alert("Apellido materno es obligatorio, debe ingresar solo letras.");
        apellido_materno.focus();
        return false;
    }

    //Valida telefono
    var telefono = document.getElementById("telefono");
    var exptelefono= /^\d{9}$/;
    if (!telefono.value.match(exptelefono) || telefono.value == "") {
        alert("Teléfono es obligatorio.  Ej:9xxxxxxxx");
        telefono.focus();
        return false;
    }

    //Validacion direccion
    var direccion = document.getElementById('direccion');
    var expDireccion = /^[a-zA-Z0-9\s]{0,100}$/;
    if (!direccion.value.match(expDireccion) || direccion.value == "") {
        alert("Dirección es obligatoria.");
        direccion.focus();
        return false;
    }

    //Valida rol
    var rol = document.getElementById("rol");
    if (rol.selectedIndex == 0) {
        alert("Debe seleccionar un rol.");
        return false;
    }

    // //Validacion correo
    // var correo = document.getElementById('correo');
    // var expCorreo = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
    // if (!correo.value.match(expCorreo) || correo.value == "") {
    //     alert("Correo es obligatorio.   Ej: xxxx@xxx.xx");
    //     correo.focus();
    //     return false;
    // }

    //Validacion password alfanumérica entre 6 y 10 caracteres
    var password = document.getElementById("password");
    var expPassword = /^\w{6,10}$/;
    if (!password.value.match(expPassword) || password == "") {
        alert("Clave alfanumérica entre 6 y 10 caracteres. \nEjemplo:b2a4e6");
        password.focus();
        return false;
    }

 return true;
}

function VerificaRut(rut) {
    
    // Despejar Puntos
    var valor = rut.replace('.','');
    // Despejar Guión
    valor = valor.replace('-','');
    
    // Aislar Cuerpo y Dígito Verificador
    cuerpo = valor.slice(0,-1);
    dv = valor.slice(-1).toUpperCase();
    
    // Formatear RUN
    // rut = cuerpo + '-'+ dv
    
    // // Si no cumple con el mínimo ej. (n.nnn.nnn)
    // if(cuerpo.length < 7) { rut.setCustomValidity("RUT Incompleto"); return false;}
    
    // Calcular Dígito Verificador
    suma = 0;
    multiplo = 2;
    
    // Para cada dígito del Cuerpo
    for(i=1;i<=cuerpo.length;i++) {
    
        // Obtener su Producto con el Múltiplo Correspondiente
        index = multiplo * valor.charAt(cuerpo.length - i);
        
        // Sumar al Contador General
        suma = suma + index;
        
        // Consolidar Múltiplo dentro del rango [2,7]
        if(multiplo < 7) { multiplo = multiplo + 1; } else { multiplo = 2; }
  
    }
    
    // Calcular Dígito Verificador en base al Módulo 11
    dvEsperado = 11 - (suma % 11);
    
    // Casos Especiales (0 y K)
    dv = (dv == 'K')?10:dv;
    dv = (dv == 0)?11:dv;
    
    // Validar que el Cuerpo coincide con su Dígito Verificador
    if(dvEsperado != dv) {
        
        return "no";
    }
    
    // Si todo sale bien, eliminar errores (decretar que es válido)
    return "si";
}

function ValidaEmpresa(){
    //Validacion Rut: 7 a 8 números seguido de guion y digito verificador numero o k
    var rut = document.getElementById('rut');
    var expRut = /^\d{7,8}\-[0-9kK]$/;
    if (!rut.value.match(expRut) || rut.value == "") {
        alert("Rut obligatorio, debe tener entre 7 y 8 números seguidos con el digito verificador.   Ej: 12345678-1");
        rut.focus();
        return false;
    }

    
    var rutEsValido = VerificaRut(rut.value);
    if(rutEsValido == 'no'){
        alert("Rut no valido, ingrese un rut válido.");
        rut.focus();
        return false;
    }

    //Validacion Nombre
    var nombre = document.getElementById('nombre');
    var expNombre = /^[a-zA-Z\s]{0,50}$/;
    if (!nombre.value.match(expNombre) || nombre.value == "") {
        alert("Nombre es obligatorio, debe ingresar solo letras, largo max de 50 caracteres.");
        nombre.focus();
        return false;
    }

    //Valida telefono
    var telefono = document.getElementById("telefono");
    var exptelefono= /^\d{9}$/;
    if (!telefono.value.match(exptelefono) || telefono.value == "") {
        alert("Teléfono es obligatorio  Ej:9xxxxxxxx");
        telefono.focus();
        return false;
    }
    // //Validacion correo
    // var correo = document.getElementById('correo');
    // var expCorreo = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
    // if (!correo.value.match(expCorreo) || correo.value == "") {
    //     alert("Correo es obligatorio.   Ej: xxxx@xxx.xx");
    //     correo.focus();
    //     return false;
    // }
    return true;

} 

function validaPrestador(){ 
    
    //Validacion Rut: 7 a 8 números seguido de guion y digito verificador numero o k
    var rut = document.getElementById('rut');
    var expRut = /^\d{7,8}\-[0-9kK]$/;
    if (!rut.value.match(expRut) || rut.value == "") {
        alert("Rut obligatorio, debe tener entre 7 y 8 números seguidos con el dígito verificador.   Ej: 12345678-1");
        rut.focus();
        return false;
    }
  
    var rutEsValido = VerificaRut(rut.value);
    if(rutEsValido == 'no'){
        alert("Rut no válido, ingrese un rut válido.");
        rut.focus();
        return false;
    }

    //Validacion Nombre
    var nombre = document.getElementById('nombre');
    var expNombre = /^[a-zA-Z\s]{0,50}$/;
    if (!nombre.value.match(expNombre) || nombre.value == "") {
        alert("Nombre es obligatorio, debe ingresar solo letras, largo max de 50 caracteres.");
        nombre.focus();
        return false;
    }
    //Valida telefono
    var telefono = document.getElementById("telefono");
    var exptelefono= /^\d{9}$/;
    if (!telefono.value.match(exptelefono) || telefono.value == "") {
        alert("Teléfono es obligatorio.  Ej:9xxxxxxxx");
        telefono.focus();
        return false;
    }

    // //Validacion correo
    // var correo = document.getElementById('correo');
    // var expCorreo = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
    // if (!correo.value.match(expCorreo) || correo.value == "") {
    //     alert("Correo es obligatorio.   Ej: xxxx@xxx.xx");
    //     correo.focus();
    //     return false;
    // }
    //Validacion direccion
    var direccion = document.getElementById('direccion');
    var expDireccion = /^[a-zA-Z0-9\s]{0,100}$/;
    if (!direccion.value.match(expDireccion) || direccion.value == "") {
        alert("Dirección es obligatoria.");
        direccion.focus();
        return false;
    }
    //Valida id_empresa
    var empresa = document.getElementById("empresa");
    if (empresa.value == '') {
        alert("Seleccione una empresa.");
        return false;
    }
    
    return true;
}

function validaActivo(){

    var patente = document.getElementById('patente');
    var expPatente = /^[aA-zZ]{4}\-\d{2}$/
    if (!patente.value.match(expPatente) || patente.value == "") {
        alert("Patente es obligatorio, ejem: XXXX-11");
        patente.focus();
        return false;
    }
    //Valida tipo vehiculo
    var tipo = document.getElementById("tipo_vehiculo");
    if (tipo.selectedIndex == 0) {
        alert("Seleccione de tipo de vehículo.");
        return false;
    }
    // validar marca
    var marca = document.getElementById('marca');
    var expMarca = /^[a-zA-Z0-9\s]{0,50}$/;
    if (!marca.value.match(expMarca) || marca.value == "") {
        alert("Marca es obligatoria.");
        marca.focus();
        return false;
    }
    // validar modelo
    var modelo = document.getElementById('modelo');
    var expModelo = /^[a-zA-Z0-9\s]{0,50}$/;
    if (!modelo.value.match(expModelo) || modelo.value == "") {
        alert("Modelo es obligatorio.");
        modelo.focus();
        return false;
    }
    //Validacion numero_motor
    var motor = document.getElementById('numero_motor');
    var expMotor = /^[a-zA-Z0-9\s]{0,50}$/;
    if (!motor.value.match(expMotor) || motor.value == "") {
        alert("Número de motor es obligatorio.");
        motor.focus();
        return false;
    }
    //Validacion numero_motor
    var chasis = document.getElementById('chasis');
    var expChasis= /^[a-zA-Z0-9\s]{0,50}$/;
    if (!chasis.value.match(expChasis) || chasis.value == "") {
        alert("Número de chasis es obligatorio.");
        chasis.focus();
        return false;
    }
    //Validacion color
    var color = document.getElementById('color');
    var expColor = /^[a-zA-Z\s]{0,20}$/;
    if (!color.value.match(expColor) || color.value == "") {
        alert("Color es obligatorio.");
        color.focus();
        return false;
    } 
    //Valida año
    var año = document.getElementById("año");
    var expAño= /^[0-9]{4}$/;
    if (!año.value.match(expAño) || año.value == "") {
        alert("Año es obligatorio.");
        año.focus();
        return false;
    }
    //Valida fecha_rev_tec
    var fecha_rev_tec = document.getElementById("fecha_rev_tec");
    if (fecha_rev_tec.value == "") {
        alert("Fecha de revisión técnica es obligatoria.");
        fecha_rev_tec.focus();
        return false;
    }
    //Valida fecha_rev_tec
    var fecha_perm_circ = document.getElementById("fecha_perm_circ");
    if (fecha_perm_circ.value == "") {
        alert("Fecha de permiso de circulación es obligatoria.");
        fecha_perm_circ.focus();
        return false;
    }
    
    //Valida combustible
    var combustible = document.getElementById("combustible");
    var expCombustible= /^[a-zA-Z\s]{0,50}$/;
    if (!combustible.value.match(expCombustible) || combustible.value == "") {
        alert("Combustible es obligatorio.");
        combustible.focus();
        return false;
    }
    //Valida transmision
    var transmision = document.getElementById("transmision");
    var expTransmision= /^[a-zA-Z\s]{0,50}$/;
    if (!transmision.value.match(expTransmision) || transmision.value == "") {
        alert("Transmisión es obligatorio.");
        transmision.focus();
        return false;
    }

    return true;


}

