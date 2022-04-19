

$("#btnIngresar").on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();

    var user = $('#Username').val();
    var clave = $('#password').val();


    let valida = "";
    valida = validarCampos(user)

    if (valida == "") {
        alert('Ingrese el usuario');
        return false;
    }

    valida = "";
    valida = validarCampos(clave)

    if (valida == "") {
        alert('Ingrese la clave');
        return false;
    }


        var usuario = {}

        usuario.UserName = user;
        usuario.Password = clave;

   
        var urlUsuario = document.baseURI + 'Login/VerificaUsuarios';

        $.ajax({
            url: urlUsuario,
            type: 'POST',
     
            data: { user: usuario },
          
            success: function (response)
            {
                if (response.mensaje != '') {
                    alert(response.mensaje);
                }
                else
                {
                    window.location.href = response.Url;
                }              
            },
            failure: function (response) {
                alert(response.responseText);
            },
            error: function (response) {
                alert(response.responseText);
            }
        });
    

});


function validarCampos(campo) {
    campo = (campo == undefined || campo == "undefined" || campo == null || campo == "") ? "" : campo;
    return campo;

}