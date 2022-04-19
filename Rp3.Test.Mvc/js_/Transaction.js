

$('#btnNuevo').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();

    $('#modaltxtCategoryId').val('');
    $('#modaltxtTransactionTypeId').val('');
    $('#modaltxtShortDescription').val('');
    $('#modaltxtAmount').val('');
    $('#modaltxtNotes').val('');

    $('#ModalActualizar').modal('show');
    $('#divTransacionId').css('visibility', 'hidden');

    var now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    document.getElementById('Iddatetime').value = now.toISOString().slice(0, 16);
    
});


$('#btnModalGrabar').click(function (ev) {
    ev.preventDefault();
    ev.stopPropagation();

    var fechaM30 = new Date();
    fechaM30.setDate(fechaM30.getDate() - 30);
    fechaM30 = fechaM30.toISOString();

    var fechaPantalla = $('#Iddatetime').val();

    var mensaje = 'La fecha seleccionada ' + fechaPantalla + ' no puede ser menor a 30 dias ' + fechaM30;

    if (fechaPantalla < fechaM30) {

        alert(mensaje);
        return false;
    }
    
    let valida = 0;
    valida= validarCampos($('#modaltxtAmount').val())
      
        if (valida <= 0 ) {
            alert('Cantidad debe ser mayor a cero (0)');
            return false;
        }

    var transaction = {}

    transaction.TransactionId = $('#modaltxtTransactionId').val();
    
    transaction.CategoryId = $('#modaltxtCategoryId').children("option:selected").val();
    transaction.TransactionTypeId = $('#modaltxtTransactionTypeId').children("option:selected").val();
    transaction.ShortDescription = $('#modaltxtShortDescription').val();
    transaction.Amount = $('#modaltxtAmount').val();
    transaction.Notes = $('#modaltxtNotes').val();
    transaction.RegisterDate = $('#Iddatetime').val();
   
    var urlGuardarTransaction = $(this).data('request-url');
   
   
    $.ajax({
        method: 'POST',
        url: urlGuardarTransaction,
      
        data: { modelTransaction: transaction },
        success: function (response) {

            alert(response.mensaje);

            $('#ModalActualizar').modal('hide');
 
            $('#modaltxtCategoryId').val('');
            $('#modaltxtTransactionTypeId').val('');
            $('#modaltxtShortDescription').val('');
            $('#modaltxtAmount').val('');
            $('#modaltxtNotes').val('');

            window.location.reload();
          
        },
        error: function (response) {
            console.log(response);
        }
    });

});


$(document).delegate('#btnEditar',
    'click',
    function (e) {      
        ActualizarTransacciones($(this).attr('TransactionId'), $(this).attr('TransactionTypeId'), $(this).attr('CategoryId'), $(this).attr('ShortDescription'), $(this).attr('Amount'), $(this).attr('Notes'), $(this).attr('RegisterDate') );
    });


function ActualizarTransacciones(TransactionId, TransactionTypeId, CategoryId, ShortDescription, Amount, Notes, RegisterDate) {

    $('#ModalActualizar').modal('show');

    $('#divTransacionId').css('visibility', 'visible');

    $('#modaltxtTransactionId').val(TransactionId);
    $('#modaltxtCategoryId').val(CategoryId);

    $('#modaltxtTransactionTypeId').val(TransactionTypeId);
    $('#modaltxtShortDescription').val(ShortDescription);
    $('#modaltxtAmount').val(Amount);
    $('#modaltxtNotes').val(Notes);

   
    let fechatmp = RegisterDate;
    fechatmp = fechatmp.split('/');
    var isLeap = new Date(fechatmp[2], fechatmp[1], fechatmp[0]);

    //var miFecha = new Date(1970, 03, 02, 0, 0, 0);

    $('#Iddatetime').val(isLeap.toLocaleString("sv-SE", {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit"
    }).replace(" ", "T"));

}

function soloNumeros(e) {
    if (e.key.match(/[0-9/\s]/i) === null) {
        e.preventDefault();
    }
}

function validarCampos(campo) {
    campo = (campo == undefined || campo == "undefined" || campo == null || campo == "") ? 0 : campo;
    return campo;

}




